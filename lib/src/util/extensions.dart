import 'package:flutter/material.dart';

/// [StateExtension] is a helper extension for [State].
extension StateExtension<T extends StatefulWidget> on State<T> {
  void mountedSetState(void Function() func) {
    func?.call();
    // ignore: invalid_use_of_protected_member
    if (mounted) setState(() {});
  }
}

/// [ObjectExtension] is a helper extension for [Object].
extension ObjectExtension on Object {
  void doIf(bool condition, void Function() func) {
    if (condition) {
      func?.call();
    }
  }
}
