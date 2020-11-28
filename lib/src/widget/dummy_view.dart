import 'package:flutter/material.dart';

/// A dummy sized view, equals to SizedBox(height: 0, width: 0).
class DummyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      width: 0,
    );
  }
}
