import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// [StateExtension] is a helper extension for [State].
extension StateExtension<T extends StatefulWidget> on State<T> {
  /// Equals to call `if (mounted) setState(() {});`
  void mountedSetState(void Function() func) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        func?.call();
      });
    }
  }
}

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

/// [TextStyleExtension] is a helper extension for [TextSpan].
extension TextStyleExtension on TextStyle {
  TextStyle underlineOffset(double dx, double dy) {
    return this.copyWith(
      color: Colors.transparent,
      shadows: [
        Shadow(
          color: this.color,
          offset: Offset(dx, dy),
        ),
      ],
    );
  }
}
