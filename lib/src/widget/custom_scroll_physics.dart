import 'package:flutter/material.dart';

// Note: The file is based on code from network blog, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Reference:
// - https://blog.csdn.net/ww897532167/article/details/125520964

// A global ClampingScrollPhysics which is used for [createBallisticSimulation].
const _clampingScrollPhysics = ClampingScrollPhysics();

// A global BouncingScrollPhysics which is used for [createBallisticSimulation].
const _bouncingScrollPhysics = BouncingScrollPhysics();

/// A customizable [ScrollPhysics] which determines the physics of scrollables by given
/// [CustomScrollPhysicsController]. Here if there is no change to [controller], the physics
/// behavior defaults to [ClampingScrollPhysics] with always scrollable.
@immutable
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({
    ScrollPhysics? parent,
    required this.controller,
  }) : super(parent: parent);

  /// The controller of [CustomScrollPhysics], it will influence scrollables physics.
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

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return controller.alwaysScrollable;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // just call global ScrollPhysics's createBallisticSimulation method
    if (controller.bouncingScroll) {
      return _bouncingScrollPhysics.createBallisticSimulation(position, velocity);
    }
    return _clampingScrollPhysics.createBallisticSimulation(position, velocity);
  }
}

/// The controller of [CustomScrollPhysics], which determines the physics of scrollables.
class CustomScrollPhysicsController {
  /// Creates a default [CustomScrollPhysicsController], which makes [CustomScrollPhysics]
  /// behave the same as [ClampingScrollPhysics].
  CustomScrollPhysicsController({
    this.disableScrollRight = false,
    this.disableScrollLeft = false,
    this.alwaysScrollable = true,
    this.bouncingScroll = false,
  });

  /// The flag to disable scrolling right (or said, swiping left), defaults to false.
  bool disableScrollRight;

  /// The flag to disable scrolling left (or said, swiping right), defaults to false.
  bool disableScrollLeft;

  /// The flag to make scrollables always accept user scroll offset, like [AlwaysScrollableScrollPhysics],
  /// defaults to true.
  bool alwaysScrollable;

  /// The flag to make [CustomScrollPhysics] behave like [BouncingScrollPhysics], defaults
  /// to false.
  bool bouncingScroll;

  // Stores the last scroll value, used in [ScrollPhysics.applyBoundaryConditions].
  double? _lastScrollValue;
}
