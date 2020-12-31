import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// [StateExtension] is a helper extension for [State].
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
const _kScrollAnimatedCurve = Curves.easeInOutQuad;

/// Default [Curve] value for [scrollDown], [scrollUp].
const _kScrollAnimatedCurve2 = Curves.easeOutCirc;

/// Default offset value for [scrollDown] and [scrollUp].
const _kScrollOffset = 50.0;

/// Default [Duration] value for [scrollWithAnimate], [scrollTop], [scrollBottom], [scrollDown] and [scrollUp].
const _kScrollAnimatedDuration = const Duration(milliseconds: 500);

/// [ScrollControllerExtension] is a helper extension for [ScrollController].
extension ScrollControllerExtension on ScrollController {
  /// Scroll to offset with default [Curve] and [Duration].
  void scrollWithAnimate(double offset, {Curve curve = _kScrollAnimatedCurve, Duration duration = _kScrollAnimatedDuration}) {
    animateTo(offset, curve: curve, duration: duration);
  }

  /// Scroll to the top of the scroll view, see [scrollWithAnimate].
  void scrollToTop({Curve curve = _kScrollAnimatedCurve, Duration duration = _kScrollAnimatedDuration}) {
    scrollWithAnimate(0.0, curve: curve, duration: duration);
  }

  /// Scroll to the bottom of the scroll view, see [scrollWithAnimate].
  void scrollToBottom({Curve curve = _kScrollAnimatedCurve, Duration duration = _kScrollAnimatedDuration}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollWithAnimate(position.maxScrollExtent, curve: curve, duration: duration);
    });
  }

  /// Scroll down (Swipe up) from the current position with offset, see [scrollWithAnimate].
  void scrollDown({double scrollOffset = _kScrollOffset, Curve curve = _kScrollAnimatedCurve2, Duration duration = _kScrollAnimatedDuration}) {
    scrollWithAnimate(offset + scrollOffset, curve: curve, duration: duration);
  }

  /// Scroll up (Swipe down) from the current position with offset, see [scrollWithAnimate].
  void scrollUp({double scrollOffset = _kScrollOffset, Curve curve = _kScrollAnimatedCurve2, Duration duration = _kScrollAnimatedDuration}) {
    scrollWithAnimate(offset - scrollOffset, curve: curve, duration: duration);
  }
}
