import 'package:flutter/material.dart';

// Reference:
// - https://github.com/Limbou/expandable_page_view/blob/main/lib/src/expandable_page_view.dart
// - https://github.com/Limbou/expandable_page_view/blob/main/lib/src/size_reporting_widget.dart

/// The direction enum type for [OverflowBox].
enum OverflowDirection {
  /// Allows overflow at horizontal direction.
  horizontal,

  /// Allows overflow at vertical direction.
  vertical,

  /// Allows overflow at both horizontal and vertical direction.
  all,
}

/// A convenient widget which makes widgets overflow-able by wrapping [OverflowBox] and [ClipRect], which can be
/// controlled by [useOverflowBox] and [useClipRect].
class OverflowClipBox extends StatelessWidget {
  const OverflowClipBox({
    Key? key,
    required this.child,
    this.useOverflowBox = true,
    this.direction = OverflowDirection.vertical,
    this.alignment = Alignment.topCenter,
    this.useClipRect = true,
    this.clipBehavior = Clip.hardEdge,
    this.width,
    this.height,
    this.padding,
    this.margin,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The flag to decide whether to use [OverflowBox] or not, defaults to true.
  final bool useOverflowBox;

  /// The overflow direction for [OverflowBox], defaults to [OverflowDirection.vertical].
  final OverflowDirection direction;

  /// The child alignment for [OverflowBox], defaults to [Alignment.topCenter].
  final Alignment alignment;

  /// The flag to decide whether to use [ClipRect] or not, defaults to true.
  final bool useClipRect;

  /// The clip behavior for [ClipRect], defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// The width of outer [OverflowBox] and [ClipRect], which may be set when using [OverflowDirection.horizontal].
  final double? width;

  /// The width of outer [OverflowBox] and [ClipRect], which may be set when using [OverflowDirection.vertical].
  final double? height;

  /// The padding insets of inner [child].
  final EdgeInsets? padding;

  /// The margin insets of outer [OverflowBox] and [ClipRect].
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    Widget? current = child;

    if (padding != null) {
      current = Padding(padding: padding!, child: current); // inner padding
    }

    if (useOverflowBox) {
      final horiz = direction == OverflowDirection.horizontal;
      final vert = direction == OverflowDirection.vertical;
      final all = direction == OverflowDirection.all;
      current = OverflowBox(
        child: current,
        alignment: alignment,
        minHeight: vert || all ? 0 : null,
        maxHeight: vert || all ? double.infinity : null,
        minWidth: horiz || all ? 0 : null,
        maxWidth: horiz || all ? double.infinity : null,
      );
    }

    if (useClipRect) {
      current = ClipRect(
        child: current,
        clipBehavior: clipBehavior,
      );
    }

    if (width != null || height != null) {
      current = SizedBox(width: width, height: height, child: current); // outer size
    }

    if (margin != null) {
      current = Padding(padding: margin!, child: current); // outer margin
    }

    return current;
  }
}
