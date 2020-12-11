import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// [ScrollControllerExtension] is a helper extension for [ScrollController].
extension ScrollControllerExtension on ScrollController {
  /// Scroll with [Curves.easeOutCirc] and 500ms duration.
  void scrollWithAnimate(double offset, {Curve curve = Curves.easeOutCirc, Duration duration = const Duration(milliseconds: 500)}) {
    animateTo(offset, curve: curve, duration: duration);
  }

  /// Scroll to the top of the scroll view, see [scrollWithAnimate].
  void scrollTop() {
    scrollWithAnimate(0.0);
  }

  /// Scroll to the bottom of the scroll view, see [scrollWithAnimate].
  void scrollBottom() {
    // See https://stackoverflow.com/questions/44141148/how-to-get-full-size-of-a-scrollcontroller.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollWithAnimate(position.maxScrollExtent);
    });
  }

  /// Scroll down from the current position with offset, see [scrollWithAnimate].
  void scrollDown({int scrollOffset = 50}) {
    scrollWithAnimate(offset + scrollOffset);
  }

  /// Scroll up from the current position with offset, see [scrollWithAnimate].
  void scrollUp({int scrollOffset = 50}) {
    scrollWithAnimate(offset - scrollOffset);
  }
}
