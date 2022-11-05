import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// An extension for [State].
extension StateExtension<T extends StatefulWidget> on State<T> {
  /// Equals to call `if (mounted) setState(() {});`
  void mountedSetState(void Function() func) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() => func());
    }
  }
}

/// An extension for [ScrollController].
extension ScrollControllerExtension on ScrollController {
  /// The default [Curve] for [scrollWithAnimate], [scrollToTop] and [scrollToBottom].
  static const _kScrollAnimationCurve = Curves.easeInOutQuint;

  /// The default [Duration] for [scrollWithAnimate], [scrollToTop] and [scrollToBottom].
  static const _kScrollAnimationDuration = Duration(milliseconds: 500);

  /// The default [Curve] for [scrollDown], [scrollUp].
  static const _kShortScrollAnimationCurve = Curves.easeOutCubic;

  /// The default [Duration] for [scrollDown] and [scrollUp].
  static const _kShortScrollAnimationDuration = Duration(milliseconds: 300);

  /// The default scroll offset for [scrollDown] and [scrollUp].
  static const _kDefaultScrollOffset = 65.0;

  /// Scrolls to given offset with default [Curve] and [Duration].
  Future<void> scrollWithAnimate(double offset, {Curve curve = _kScrollAnimationCurve, Duration duration = _kScrollAnimationDuration}) async {
    if (hasClients) {
      await animateTo(offset, curve: curve, duration: duration);
    }
  }

  /// Scrolls to the top of the scroll view, see [scrollWithAnimate].
  Future<void> scrollToTop({Curve curve = _kScrollAnimationCurve, Duration duration = _kScrollAnimationDuration}) {
    return scrollWithAnimate(0.0, curve: curve, duration: duration);
  }

  /// Scrolls to the bottom of the scroll view, see [scrollWithAnimate], note that you may need to use
  /// [SchedulerBinding.addPostFrameCallback] to perform the operation.
  Future<void> scrollToBottom({Curve curve = _kScrollAnimationCurve, Duration duration = _kScrollAnimationDuration}) {
    return scrollWithAnimate(position.maxScrollExtent, curve: curve, duration: duration);
  }

  /// Scrolls down (or said, swipe up) from the current position with [scrollOffset], see [scrollWithAnimate].
  Future<void> scrollDown({double scrollOffset = _kDefaultScrollOffset, Curve curve = _kShortScrollAnimationCurve, Duration duration = _kShortScrollAnimationDuration}) {
    return scrollWithAnimate(offset + scrollOffset, curve: curve, duration: duration);
  }

  /// Scrolls up (or said, swipe down) from the current position with [scrollOffset], see [scrollWithAnimate].
  Future<void> scrollUp({double scrollOffset = _kDefaultScrollOffset, Curve curve = _kShortScrollAnimationCurve, Duration duration = _kShortScrollAnimationDuration}) {
    return scrollWithAnimate(offset - scrollOffset, curve: curve, duration: duration);
  }

  /// Checks whether given [ScrollPosition] has been attached, and detaches it.
  bool checkAndDetach(ScrollPosition position) {
    if (!positions.contains(position)) {
      return false;
    }
    detach(position);
    return true;
  }

  /// Checks whether current scroll offset is larger than given threshold, or is in the bottom of
  /// scroll view.
  bool isScrollOver(double threshold, {double maxScrollExtentError = 1.0}) {
    return hasClients && (offset >= threshold || offset >= position.maxScrollExtent * maxScrollExtentError);
  }
}

/// An extension for [ScrollMetrics].
extension ScrollMetricsExtension on ScrollMetrics {
  /// Checks if the size of scrollable area is shorter than parent.
  bool isShortScrollArea() {
    return maxScrollExtent == 0.0;
  }

  /// Checks if the current scroll position stays in the top of scroll view exactly, or out of its range.
  bool atTopEdge() {
    return pixels <= minScrollExtent;
  }

  /// Checks if the current scroll position stays in the bottom of scroll view exactly, or out of its range.
  bool atBottomEdge() {
    return pixels >= maxScrollExtent;
  }
}

/// An extension for [PageController].
extension PageControllerExtension on PageController {
  // PageController:
  // - animateTo(double offset, {required Duration duration, required Curve curve})
  // - animateToPage(int page, {required Duration duration, required Curve curve})
  // - jumpTo(double value)
  // - jumpToPage(int page)
  //
  // TabController:
  // - animateTo(int value, {Duration? duration, Curve curve = Curves.ease})
  // - set index(int value)
  // - get offset(double value)

  /// The default [Curve] for [defaultAnimateToPage].
  static const _kPageAnimationCurve = Curves.ease;

  /// The default [Duration] for [defaultAnimateToPage].
  static const _kPageAnimationDuration = kTabScrollDuration; // Duration(milliseconds: 300)

  /// Animates the position from its current value to the given value, with two optional animation settings.
  ///
  /// This is almost the same as [ScrollController.animateTo], except for two optional parameters which
  /// have its default value.
  Future<void> defaultAnimateTo(double offset, {Curve curve = _kPageAnimationCurve, Duration duration = _kPageAnimationDuration}) {
    return animateTo(offset, curve: curve, duration: duration);
  }

  /// Animates the controlled [PageView] from the current page to the given page.
  ///
  /// This is almost the same as [ScrollController.animateToPage], except for two optional parameters which
  /// have its default value.
  Future<void> defaultAnimateToPage(int page, {Curve curve = _kPageAnimationCurve, Duration duration = _kPageAnimationDuration}) {
    return animateToPage(page, curve: curve, duration: duration);
  }
}

/// An extension for [RenderObject].
extension RenderObjectExtension on RenderObject {
  /// Returns the [Rect] which contains the size (semantic bound size) and position (in the coordinate
  /// system of root node) of render object.
  Rect getBoundInRootAncestorCoordinate() {
    var translation = getTransformTo(null).getTranslation();
    var size = semanticBounds.size;
    return Rect.fromLTWH(translation.x, translation.y, size.width, size.height);
  }

  /// Casts the [RenderObject] to [RenderBox].
  RenderBox? toRenderBox() {
    return this as RenderBox?;
  }
}
