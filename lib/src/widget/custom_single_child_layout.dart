import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A customizable [SingleChildLayoutDelegate] which is used by [CustomSingleChildLayout] or
/// [RenderCustomSingleChildLayoutBox]. Here this delegate will use given function
/// parameters as override methods.
class CustomSingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  const CustomSingleChildLayoutDelegate({
    this.sizeGetter,
    this.constraintsGetter,
    this.positionGetter,
    this.relayoutChecker,
  });

  /// The size of this object given the incoming constraints.
  final Size Function(BoxConstraints constraints)? sizeGetter;

  /// The constraints for the child given the incoming constraints.
  final BoxConstraints Function(BoxConstraints constraints)? constraintsGetter;

  /// The position where the child should be placed.
  final Offset Function(Size size, Size childSize)? positionGetter;

  /// The checker function to determine whether new instance is different from the old one.
  final bool Function()? relayoutChecker;

  @override
  Size getSize(BoxConstraints constraints) {
    return sizeGetter?.call(constraints) ?? constraints.biggest;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraintsGetter?.call(constraints) ?? constraints;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionGetter?.call(size, childSize) ?? Offset.zero;
  }

  @override
  bool shouldRelayout(covariant CustomSingleChildLayoutDelegate oldDelegate) {
    return relayoutChecker?.call() ?? true;
  }
}
