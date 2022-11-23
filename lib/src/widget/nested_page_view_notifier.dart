import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget to enable or notify scrolling of [PageView] which contains another [PageView] or
/// [TabBarView] inside.
///
/// Note that a [TabBarView] can also be treated as a [PageView] because of its implementation,
/// you can use [context.visitDescendantElementsDFS] or [context.visitDescendantElementsBFS]
/// which are extended by flutter_ahlib to get its [PageController].
///
/// Example:
/// ```
/// PageView(
///   controller: _controller,
///   children: [
///     Column(
///       children: [
///         TabBar(
///           tabs: [ /* tabs */ ],
///         ),
///         Expanded(
///           child: NestedPageViewScrollable(
///             parentController: _controller,
///             child: TabBarView(
///               children: [ /* pages */ ],
///             ),
///           ),
///         ),
///       ],
///     ),
///     // other pages...
///   ],
/// );
/// ```
class NestedPageViewNotifier extends StatefulWidget {
  const NestedPageViewNotifier({
    Key? key,
    required this.child,
    required this.parentController,
  }) : super(key: key);

  /// The widget below this widget in the tree, typically is a [PageView] or [TabBarView] widget.
  final Widget child;

  /// The page controller of outer [PageView]. This widget will have no effect if this value is null.
  final PageController? parentController;

  @override
  State<NestedPageViewNotifier> createState() => _NestedPageViewNotifierState();
}

class _NestedPageViewNotifierState extends State<NestedPageViewNotifier> {
  @override
  Widget build(BuildContext context) {
    DragStartDetails? dragStartDetails;
    Drag? drag;
    return NotificationListener(
      onNotification: (n) {
        if (widget.parentController == null) {
          return false;
        }

        if (n is ScrollStartNotification && n.dragDetails != null) {
          dragStartDetails = n.dragDetails!;
          return true;
        }
        if (n is OverscrollNotification && dragStartDetails != null && n.dragDetails != null && n.dragDetails!.delta.dy == 0) {
          drag ??= widget.parentController!.position.drag(dragStartDetails!, () {});
          drag!.update(n.dragDetails!); // update PageView's scroll position
          return true;
        }
        if (n is OverscrollIndicatorNotification && drag != null) {
          n.disallowIndicator(); // disable TabBarView's glow effect
          return true;
        }
        if (n is ScrollEndNotification) {
          drag?.cancel();
          drag = null;
          dragStartDetails = null;
          return true;
        }

        return false;
      },
      child: widget.child,
    );
  }
}
