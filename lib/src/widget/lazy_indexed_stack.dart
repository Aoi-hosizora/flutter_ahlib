import 'package:flutter/material.dart';

/// An [IndexedStack] which loads children in lazy.
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  /// The alignment of this widget, defaults to [AlignmentDirectional.topStart].
  final AlignmentGeometry? alignment;

  /// The textDirection of this widget.
  final TextDirection? textDirection;

  /// The sizing of this widget, defaults to [StackFit.loose].
  final StackFit? sizing;

  /// The index of this widget.
  final int index;

  /// The item count of this widget.
  final int itemCount;

  /// The item builder of this widget.
  final IndexedWidgetBuilder itemBuilder;

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  final _children = <Widget>[];
  final _loaded = <bool>[];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.itemCount; i++) {
      if (i == widget.index) {
        _children.add(widget.itemBuilder(context, i));
        _loaded.add(true); // loaded
      } else {
        _children.add(const SizedBox.shrink()); // dummy child
        _loaded.add(false);
      }
    }
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var i = 0; i < widget.itemCount; i++) {
      if (i != widget.index) {
        continue;
      }
      if (_loaded[i]) {
        continue;
      }
      _children[i] = widget.itemBuilder(context, i);
      _loaded[i] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: widget.alignment ?? AlignmentDirectional.topStart,
      textDirection: widget.textDirection,
      sizing: widget.sizing ?? StackFit.loose,
      index: widget.index,
      children: _children,
    );
  }
}

/// A data class represents arguments of [Positioned] only except for its [child].
class PositionArgument {
  /// Creates a [PositionArgument] from given parameters.
  const PositionArgument({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });

  /// Creates a [PositionArgument] from given [left], [top], [right] and [bottom] in order.
  const PositionArgument.fromLTRB(this.left, this.top, this.right, this.bottom)
      : width = null,
        height = null;

  /// Creates a [PositionArgument] where [left], [top], [right] and [bottom] are all `value`.
  const PositionArgument.all(double value) //
      : this.fromLTRB(value, value, value, value);

  /// Creates a [PositionArgument] where [left], [top], [right] and [bottom] default to zero.
  const PositionArgument.fill({this.left = 0.0, this.top = 0.0, this.right = 0.0, this.bottom = 0.0})
      : width = null,
        height = null;

  /// Creates a [PositionArgument] from given [Rect].
  ///
  /// This sets the [left], [top], [width], and [height] properties from the given [Rect].
  /// The [right] and [bottom] properties are set to null.
  PositionArgument.fromRect(Rect rect)
      : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null;

  /// Creates a [PositionArgument] from given [RelativeRect].
  ///
  /// This sets the [left], [top], [right], and [bottom] properties from the given [RelativeRect].
  /// The [height] and [width] properties are set to null.
  PositionArgument.fromRelativeRect(RelativeRect rect)
      : left = rect.left,
        top = rect.top,
        right = rect.right,
        bottom = rect.bottom,
        width = null,
        height = null;

  /// Mirrors to [Positioned.left].
  final double? left;

  /// Mirrors to [Positioned.top].
  final double? top;

  /// Mirrors to [Positioned.right].
  final double? right;

  /// Mirrors to [Positioned.bottom].
  final double? bottom;

  /// Mirrors to [Positioned.width].
  final double? width;

  /// Mirrors to [Positioned.height].
  final double? height;
}
