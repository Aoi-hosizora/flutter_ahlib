import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget to enable or notify scrolling of [PageView] which contains another [PageView] or
/// [TabBarView] inside.
///
/// Note that a [TabBarView] can also be treated as a [PageView] because of its implementation,
/// you can use [BuildContext.findAncestorWidgetOfExactType] or [BuildContext.visitDescendantElementsBFS]
/// to get its inner [PageController].
///
/// Example:
/// ```
/// PageView(
///   controller: _controller,
///   children: [
///     // other pages...
///     Column(
///       children: [
///         TabBar(...),
///         Expanded(
///           child: NestedPageViewScrollable(
///             parentController: _controller,
///             child: TabBarView(...),
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
  DragStartDetails? _dragStartDetails;
  Drag? _drag;

  bool _onNotification(Notification n) {
    if (widget.parentController == null) {
      return false;
    }

    if (n is ScrollStartNotification && n.dragDetails != null) {
      _dragStartDetails = n.dragDetails!;
      return true;
    }
    if (n is OverscrollNotification && _dragStartDetails != null && n.dragDetails != null && n.dragDetails!.delta.dy == 0) {
      _drag ??= widget.parentController!.position.drag(_dragStartDetails!, () {});
      _drag!.update(n.dragDetails!); // update PageView's scroll position
      return true;
    }
    if (n is OverscrollIndicatorNotification && _drag != null) {
      n.disallowIndicator(); // disable TabBarView's glow effect
      return true;
    }
    if (n is ScrollEndNotification) {
      _drag?.cancel();
      _drag = null;
      _dragStartDetails = null;
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: widget.child,
    );
  }
}
