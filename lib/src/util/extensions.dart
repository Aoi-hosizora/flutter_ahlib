import 'package:flutter/material.dart';

/// [StateExtension] is a helper extension for [State].
extension StateExtension<T extends StatefulWidget> on State<T> {
  /// Equals to call `if (mounted) setState(() {});`
  void mountedSetState(void Function() func) {
    func?.call();
    // ignore: invalid_use_of_protected_member
    if (mounted) setState(() {});
  }
}

/// [ObjectExtension] is a helper extension for [Object].
extension ObjectExtension on Object {
  /// [doIf] can use lambda for `if` statement.
  void doIf(bool condition, void Function() func) {
    if (condition) {
      func?.call();
    }
  }

  /// [doIfElse] can use lambda for `if-else` statement.
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
    if (this) {
      return func?.call();
    }
    return null;
  }
}
