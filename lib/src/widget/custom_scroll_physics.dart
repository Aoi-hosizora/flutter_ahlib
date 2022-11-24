import 'package:flutter/material.dart';

// Note: The file is based on code from network blog, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Reference:
// - https://blog.csdn.net/ww897532167/article/details/125520964

///
@immutable
class CustomScrollPhysics extends ClampingScrollPhysics {
  const CustomScrollPhysics({
    ScrollPhysics? parent,
    required this.controller,
  }) : super(parent: parent);

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
    if (controller.bouncingScroll) {
      // make it just like BouncingScrollPhysics
      return 0;
    }

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
}

///
class CustomScrollPhysicsController {
  /// Creates a default [CustomScrollPhysicsController], which makes [CustomScrollPhysics]
  /// behave the same as [ClampingScrollPhysics].
  CustomScrollPhysicsController({
    this.disableScrollRight = false,
    this.disableScrollLeft = false,
    this.bouncingScroll = false,
  });

  /// The flag to disable scrolling right, or said swiping left, defaults to false.
  bool disableScrollRight;

  /// The flag to disable scrolling left, or said swiping right, defaults to false.
  bool disableScrollLeft;

  /// The flag to allow the scroll offset to go beyond the bounds of the content,
  /// and bounce the content back to the edge of those bounds, just like [BouncingScrollPhysics],
  /// defaults to false.
  bool bouncingScroll;

  /// Stores the last scroll value, used in [ScrollPhysics.applyBoundaryConditions].
  double? _lastScrollValue;
}
