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

/// [ObjectExtension] is a helper extension for [Object].
extension ObjectExtension on Object {
  /// Makes `if` can be used in lambda expression.
  void doIf(bool condition, void Function() func) {
    if (condition) {
      func?.call();
    }
  }

  /// Makes `if-else` can be used in lambda expression.
  void doIfElse(bool condition, void Function() ifFunc, void Function() elseFunc) {
    if (condition) {
      ifFunc?.call();
    } else {
      elseFunc?.call();
    }
  }
}

/// [BoolExtension] is a helper extension for [bool].
extension BoolExtension on bool {
  /// Returns value if condition is true.
  T returnIfTrue<T>(T Function() func) {
    if (this) {
      return func?.call();
    }
    return null;
  }

  /// Returns value if condition is false.
  T returnIfFalse<T>(T Function() func) {
    if (!this) {
      return func?.call();
    }
    return null;
  }

  /// Returns value1 if condition is true, otherwise return value2.
  T returnIf<T>(T Function() ifFunc, T Function() elseFunc) {
    if (this) {
      return ifFunc?.call();
    } else {
      return elseFunc?.call();
    }
  }
}

/// [ListExtension] is a helper extension for [List].
extension ListExtension<T> on List<T> {
  /// Returns a new list with separator between items.
  List<T> separate(T separator) {
    return [
      if (this.length > 0) this[0],
      for (var idx = 1; idx < this.length; idx++) ...[
        separator,
        this[idx],
      ],
    ];
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

