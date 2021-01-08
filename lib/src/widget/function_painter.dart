import 'dart:ui';

import 'package:flutter/material.dart';

/// A [CustomPainter] is a widget extended from [CustomPainter] which uses a function to [paint].
class FunctionPainter extends CustomPainter {
  const FunctionPainter({
    @required this.onPaint,
    this.repaint = false,
  })  : assert(onPaint != null),
        assert(repaint != null);

  /// [paint] function for [CustomPainter].
  final void Function(Canvas, Size) onPaint;

  /// Should repaint, see [shouldRepaint].
  final bool repaint;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint.call(canvas, size);
  }

  @override
  bool shouldRepaint(FunctionPainter oldDelegate) {
    return repaint;
  }
}
