import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// This widget can be used to enable scrolling for [TabBarView] inside [PageView]. It needs the
/// [PageController] and uses [ScrollController.position] to update [Drag] in [NotificationListener].
class TabInPageNotification extends StatelessWidget {
  const TabInPageNotification({
    Key key,
    @required this.child,
    @required this.pageController,
  })  : assert(child != null),
        assert(pageController != null),
        super(key: key);

  /// Notification child, which is almost [TabBarView].
  final Widget child;

  /// [PageController] for outer [PageView], used in [NotificationListener].
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    DragStartDetails dragStartDetails;
    Drag drag;
    return NotificationListener(
      onNotification: (n) {
        if (n is ScrollStartNotification) {
          dragStartDetails = n.dragDetails;
        }
        if (n is OverscrollNotification && n.dragDetails.delta.dy == 0) {
          drag = pageController.position.drag(dragStartDetails, () {});
          drag.update(n.dragDetails); // <<<
        }
        if (n is ScrollEndNotification) {
          drag?.cancel();
        }
        return true;
      },
      child: child,
    );
  }
}
