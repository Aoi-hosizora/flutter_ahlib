import 'dart:ui';

import 'package:flutter/material.dart';

/// A [CustomPainter] that uses given [paint] function to paint.
class FunctionPainter extends CustomPainter {
  const FunctionPainter({
    @required this.onPaint,
    this.repaint = false,
  })  : assert(onPaint != null),
        assert(repaint != null);

  /// The paint function of [CustomPainter].
  final void Function(Canvas, Size) onPaint;

  /// The switcher of should repaint, see [CustomPainter.shouldRepaint], defaults to false.
  final bool repaint;

  /// Paints, overrides [CustomPainter].
  @override
  void paint(Canvas canvas, Size size) {
    onPaint.call(canvas, size);
  }

  @override
  bool shouldRepaint(FunctionPainter oldDelegate) {
    return repaint;
  }
}
