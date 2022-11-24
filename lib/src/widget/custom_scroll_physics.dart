import 'package:flutter/material.dart';

// Note: The file is referred from network blog, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Reference:
// - https://blog.csdn.net/ww897532167/article/details/125520964

/// A customizable [ScrollPhysics] which determines [Scrollable] physics by given
/// [CustomScrollPhysicsController]. If there is no change on [controller], it will
/// default to how [ClampingScrollPhysics] behaves and always accept user scroll.
@immutable
class CustomScrollPhysics extends ClampingScrollPhysics {
  const CustomScrollPhysics({
    ScrollPhysics? parent,
    required this.controller,
  }) : super(parent: parent);

  /// The controller of [CustomScrollPhysics], it is mutable and will influence the
  /// physics of [Scrollable] dynamically.
  final CustomScrollPhysicsController controller;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      parent: buildParent(ancestor),
      controller: controller,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final lastScrollValue = controller._lastScrollValue;
    if (lastScrollValue != null) {
      if (value > lastScrollValue && controller.disableScrollRight) {
        // value turns larger => scroll right, or said swipe left
        return value - position.pixels;
      }
      if (value < lastScrollValue && controller.disableScrollLeft) {
        // value turns smaller => scroll left, or said swipe left
        return value - position.pixels;
      }
    }
    controller._lastScrollValue = value;

    return super.applyBoundaryConditions(position, value);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true; // default to AlwaysScrollableScrollPhysics
  }
}

/// The controller of [CustomScrollPhysics], which determines the physics of [Scrollable].
class CustomScrollPhysicsController {
  CustomScrollPhysicsController({
    this.disableScrollRight = false,
    this.disableScrollLeft = false,
  });

  /// The flag for disabling scrolling right (or said, swiping left), even if current
  /// offset lands on the middle of items, defaults to false.
  bool disableScrollRight;

  /// The flag for disabling scrolling left (or said, swiping right), even if current
  /// offset lands on the middle of items, defaults to false.
  bool disableScrollLeft;

  // Stores the last scroll value, is used in applyBoundaryConditions.
  double? _lastScrollValue;
}
