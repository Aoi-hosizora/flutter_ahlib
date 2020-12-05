import 'package:flutter/material.dart';

/// [MountedSetStateExtension] is a helper extension for writing [setState] with [mounted] in lambda.
extension MountedSetStateExtension<T extends StatefulWidget> on State<T> {
  void mountedSetState(void Function() func) {
    func?.call();
    // ignore: invalid_use_of_protected_member
    if (mounted) setState(() {});
  }
}
