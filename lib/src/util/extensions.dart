import 'package:flutter/material.dart';

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
