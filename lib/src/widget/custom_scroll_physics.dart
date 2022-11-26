import 'package:flutter/material.dart';

// Reference:
// - https://blog.csdn.net/ww897532167/article/details/125520964

/// A customizable [ScrollPhysics] which determines [Scrollable] physics by given
/// [CustomScrollPhysicsController]. If there is no change on [controller], it will
/// default to how [ClampingScrollPhysics] behaves and always accept user scroll.
@immutable
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({
    ScrollPhysics? parent = const ClampingScrollPhysics(),
    this.controller,
  }) : super(parent: parent);

  /// The controller of [CustomScrollPhysics], it is mutable and will influence the
  /// physics of [Scrollable] dynamically.
  final CustomScrollPhysicsController? controller;

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      parent: buildParent(ancestor ?? const ClampingScrollPhysics()),
      controller: controller,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (controller == null) {
      return super.applyBoundaryConditions(position, value);
    }

    final lastScrollValue = controller!._lastScrollValue;
    if (lastScrollValue != null) {
      if (value > lastScrollValue && controller!.disableScrollMore) {
        // value turns larger => scroll more
        return value - position.pixels;
      }
      if (value < lastScrollValue && controller!.disableScrollLess) {
        // value turns smaller => scroll less
        return value - position.pixels;
      }
    }
    controller!._lastScrollValue = value;

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
    this.disableScrollMore = false,
    this.disableScrollLess = false,
  });

  /// The flag to disable scrolling more (or said, scroll right/down or swipe left/up),
  /// even if current offset lands on the middle of items, defaults to false.
  bool disableScrollMore;

  /// The flag to disable scrolling less (or said, scroll left/up or swipe right/down),
  /// even if current offset lands on the middle of items, defaults to false.
  bool disableScrollLess;

  // Stores the last scroll value, is used in applyBoundaryConditions.
  double? _lastScrollValue;
}
