import 'package:flutter/material.dart';

/// A sliver that contains a single box widget, is a replacement of [SliverToBoxAdapter].
class SliverContainer extends StatelessWidget {
  const SliverContainer({
    Key key,
    this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.color,
    this.decoration,
    this.constraints,
    this.alignment,
    this.foregroundDecoration,
    this.transform,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  /// The child contained by the container.
  final Widget child;

  /// Empty space to inscribe inside the [decoration]. The [child] is placed inside this padding.
  final EdgeInsets padding;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry margin;

  /// Height of the container.
  final double height;

  /// Width of the container.
  final double width;

  /// The color to paint behind the [child].
  final Color color;

  /// The decoration to paint behind the [child].
  final Decoration decoration;

  /// Additional constraints to apply to the child.
  final BoxConstraints constraints;

  /// Align the [child] within the container.
  final AlignmentGeometry alignment;

  /// The decoration to paint behind the [child].
  final Decoration foregroundDecoration;

  /// The transformation matrix to apply before painting the container.
  final Matrix4 transform;

  /// The clip behavior when [Container.decoration] has a clipPath.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: this.child,
        padding: this.padding,
        margin: this.margin,
        height: this.height,
        width: this.width,
        color: this.color,
        decoration: this.decoration,
        constraints: this.constraints,
        alignment: this.alignment,
        foregroundDecoration: this.foregroundDecoration,
        transform: this.transform,
        clipBehavior: this.clipBehavior,
      ),
    );
  }
}
