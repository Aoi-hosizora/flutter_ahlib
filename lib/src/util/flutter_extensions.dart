import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A helper extension for [State].
extension StateExtension<T extends StatefulWidget> on State<T> {
  /// Equals to call `if (mounted) setState(() {});`
  void mountedSetState(void Function() func) {
    if (this != null && mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() => func?.call());
    }
  }
}

/// Default [Curve] value for [scrollWithAnimate], [scrollTop] and [scrollBottom].
const _kAnimatedScrollCurve = Curves.easeInOutQuint;

/// Default [Duration] value for [scrollWithAnimate], [scrollTop] and [scrollBottom].
const _kAnimatedScrollDuration = const Duration(milliseconds: 500);

/// Default offset value for [scrollDown] and [scrollUp].
const _kAnimatedScrollOffset = 65.0;

/// Default [Curve] value for [scrollDown], [scrollUp].
const _kAnimatedScrollCurve2 = Curves.easeOutCirc;

/// Default [Duration] value for [scrollDown] and [scrollUp].
const _kAnimatedScrollDuration2 = const Duration(milliseconds: 300);

/// A helper extension for [ScrollController].
extension ScrollControllerExtension on ScrollController {
  /// Scroll to offset with default [Curve] and [Duration].
  Future<void> scrollWithAnimate(double offset, {Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    return animateTo(offset, curve: curve, duration: duration);
  }

  /// Scroll to the top of the scroll view, see [scrollWithAnimate].
  Future<void> scrollToTop({Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    return scrollWithAnimate(0.0, curve: curve, duration: duration);
  }

  /// Scroll to the bottom of the scroll view, see [scrollWithAnimate].
  void scrollToBottom({Curve curve = _kAnimatedScrollCurve, Duration duration = _kAnimatedScrollDuration}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollWithAnimate(position.maxScrollExtent, curve: curve, duration: duration);
    });
  }

  /// Scroll down (Swipe up) from the current position with offset, see [scrollWithAnimate].
  Future<void> scrollDown({double scrollOffset = _kAnimatedScrollOffset, Curve curve = _kAnimatedScrollCurve2, Duration duration = _kAnimatedScrollDuration2}) {
    return scrollWithAnimate(offset + scrollOffset, curve: curve, duration: duration);
  }

  /// Scroll up (Swipe down) from the current position with offset, see [scrollWithAnimate].
  Future<void> scrollUp({double scrollOffset = _kAnimatedScrollOffset, Curve curve = _kAnimatedScrollCurve2, Duration duration = _kAnimatedScrollDuration2}) {
    return scrollWithAnimate(offset - scrollOffset, curve: curve, duration: duration);
  }
}

/// A helper extension for [PageController].
extension PageControllerExtension on PageController {
  /// An optional parameters version of [animateToPage], is like as [ScrollController.animateTo]. Both of [animateTo] and [animateToPage]'s parameters are all required.
  Future<void> defaultAnimateToPage(int page, {Curve curve = Curves.easeOutQuad, Duration duration = kTabScrollDuration}) {
    return animateToPage(page, curve: curve, duration: duration);
  }
}

/// A helper extension for [ScrollMetrics].
extension ScrollMetricsExtension on ScrollMetrics {
  /// Check the scrollable area is short.
  bool isShortScroll() {
    return maxScrollExtent == 0;
  }

  /// Check the current scroll position is in the bottom.
  bool isInBottom() {
    return pixels >= maxScrollExtent && !outOfRange;
  }
}
