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

/// Default [Curve] value for [scrollWithAnimate], [scrollToTop] and [scrollToBottom].
const _kAnimatedScrollCurve = Curves.easeInOutQuint;

/// Default [Duration] value for [scrollWithAnimate], [scrollToTop] and [scrollToBottom].
const _kAnimatedScrollDuration = Duration(milliseconds: 500);

/// Default offset value for [scrollDown] and [scrollUp].
const _kAnimatedScrollOffset = 65.0;

/// Default [Curve] value for [scrollDown], [scrollUp].
const _kAnimatedLocalScrollCurve = Curves.easeOutCirc;

/// Default [Duration] value for [scrollDown] and [scrollUp].
const _kAnimatedLocalScrollDuration = Duration(milliseconds: 300);

/// An extension for [ScrollController].
extension ScrollControllerExtension on ScrollController {
  /// Scrolls to offset with default [Curve] and [Duration].
  Future<void> scrollWithAnimate(double offset, {Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    return animateTo(offset, curve: curve, duration: duration);
  }

  /// Scrolls to the top of the scroll view, see [scrollWithAnimate].
  Future<void> scrollToTop({Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    return scrollWithAnimate(0.0, curve: curve, duration: duration);
  }

  /// Scrolls to the bottom of the scroll view, see [scrollWithAnimate], note that you may need to use
  /// [SchedulerBinding.instance.addPostFrameCallback] to perform the operation.
  Future<void> scrollToBottom({Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    return scrollWithAnimate(position.maxScrollExtent, curve: curve, duration: duration);
  }

  /// Scrolls down (swipe up) from the current position with offset, see [scrollWithAnimate].
  Future<void> scrollDown({double scrollOffset = _kAnimatedScrollOffset, Curve curve = _kAnimatedLocalScrollCurve, Duration duration = _kAnimatedLocalScrollDuration}) {
    return scrollWithAnimate(offset + scrollOffset, curve: curve, duration: duration);
  }

  /// Scrolls up (swipe down) from the current position with offset, see [scrollWithAnimate].
  Future<void> scrollUp({double scrollOffset = _kAnimatedScrollOffset, Curve curve = _kAnimatedLocalScrollCurve, Duration duration = _kAnimatedLocalScrollDuration}) {
    return scrollWithAnimate(offset - scrollOffset, curve: curve, duration: duration);
  }
}

/// Default [Curve] value for [defaultAnimateToPage].
const _kPageScrollCurve = Curves.easeOutQuad;

/// Default [Duration] value for [defaultAnimateToPage].
const _kPageScrollDuration = kTabScrollDuration;

/// An extension for [PageController].
extension PageControllerExtension on PageController {
  /// This is almost the same as [ScrollController.animateTo], but has two optional parameters. Here [page]
  /// is required, but [curve] and [duration] have its default values.
  Future<void> defaultAnimateToPage(int page, {Curve curve = _kPageScrollCurve, Duration duration = _kPageScrollDuration}) {
    return animateToPage(page, curve: curve, duration: duration);
  }
}

/// An extension for [ScrollMetrics].
extension ScrollMetricsExtension on ScrollMetrics {
  /// Checks if the scrollable area's size is shorter than parent.
  bool isShortScrollArea() {
    return maxScrollExtent == 0.0;
  }

  /// Checks if the current scroll position is in the bottom of the parent.
  bool isInBottom() {
    return pixels >= maxScrollExtent && !outOfRange;
    // return extentAfter == 0.0 && !outOfRange; // extentAfter => math.max(maxScrollExtent - pixels, 0.0)
  }
}
