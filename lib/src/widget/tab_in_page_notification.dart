import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget that can be used to enable scrolling for [TabBarView] inside [PageView], this widget needs [PageView]'s
/// [PageController] and will use [ScrollController.position] to update [Drag] in [NotificationListener].
class TabInPageNotification extends StatelessWidget {
  const TabInPageNotification({
    Key? key,
    required this.child,
    required this.pageController,
  }) : super(key: key);

  /// The child used to notified scroll, which is almost [TabBarView].
  final Widget child;

  /// The page controller of outer [PageView], which will be used in [NotificationListener].
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    DragStartDetails? dragStartDetails;
    Drag? drag;
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollStartNotification && n.dragDetails != null) {
          dragStartDetails = n.dragDetails!;
        }
        if (n is OverscrollNotification && n.dragDetails != null && dragStartDetails != null) {
          if (n.dragDetails!.delta.dy == 0) {
            drag = pageController.position.drag(dragStartDetails!, () {});
            drag!.update(n.dragDetails!); // <<<
          }
        }
        if (n is ScrollEndNotification) {
          drag?.cancel();
          drag = null;
          dragStartDetails = null;
        }
        return true;
      },
      child: child,
    );
  }
}
