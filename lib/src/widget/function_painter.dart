import 'dart:ui';

import 'package:flutter/material.dart';

/// A [CustomPainter] which uses a function to [paint] and will never repaint.
class FunctionPainter extends CustomPainter {
  const FunctionPainter({
    @required this.onPaint,
  }) : assert(onPaint != null);

  /// [paint] function for [CustomPainter].
  final void Function(Canvas, Size) onPaint;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint?.call(canvas, size);
  }

  @override
  bool shouldRepaint(FunctionPainter oldDelegate) {
    return false;
  }
}

/// An [Icon] with a line from left top to bottom right, which is rendered by [CustomPaint].
class BannedIcon extends StatelessWidget {
  const BannedIcon({
    Key key,
    @required this.icon,
    this.banned = true,
    @required this.color,
    @required this.backgroundColor,
    this.offset = 3.0,
    this.lineWidth = 3.0,
    this.blinkLineWidth = 2.0,
    this.size = Size.zero,
  })  : assert(icon != null),
        assert(banned != null),
        assert(offset != null),
        assert(color != null),
        assert(backgroundColor != null),
        assert(lineWidth != null),
        assert(blinkLineWidth != null),
        assert(size != null),
        super(key: key);

  /// Content icon, the shape of line depends on this widget's size.
  final Widget icon;

  /// Paint the line or not.
  final bool banned;

  /// Color of line, need to be the same as icon's color.
  final Color color;

  /// Color of background, used to paint the blink line.
  final Color backgroundColor;

  /// Line position offset from the icon size, default is 3.0.
  final double offset;

  /// Line width, default is 3.0.
  final double lineWidth;

  /// Blink link width, default is 2.0, recommend to set a value that close to [lineWidth].
  final double blinkLineWidth;

  /// Icon size, default is [Size.zero] which depends on the child or parent.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        foregroundPainter: !banned
            ? null
            : FunctionPainter(
                onPaint: (canvas, size) {
                  // line
                  canvas.drawLine(
                    Offset(offset, offset),
                    Offset(size.width - offset, size.height - offset),
                    Paint()
                      ..color = color
                      ..strokeWidth = lineWidth,
                  );
                  // blink line
                  canvas.drawLine(
                    Offset(offset, offset - blinkLineWidth),
                    Offset(size.width - offset + blinkLineWidth, size.height - offset),
                    Paint()
                      ..color = backgroundColor
                      ..strokeWidth = blinkLineWidth,
                  );
                },
              ),
        child: icon,
        size: size,
        willChange: banned ? true : false,
      ),
    );
  }
}
