import 'package:flutter/material.dart';

// Reference:
// - https://blog.csdn.net/ww897532167/article/details/125520964

/// A customizable [ScrollPhysics] which determines [Scrollable] physics by given
/// [CustomScrollPhysicsController]. If there is no change on [controller], it will
/// default to how [ClampingScrollPhysics] behaves and always accept user scroll.
///
/// Note that you can use [DefaultScrollPhysics] inherited widget to define a
/// default physics, and use [DefaultScrollPhysics.of] to get it in children.
@immutable
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({
    ScrollPhysics? parent = const ClampingScrollPhysics(),
    this.controller,
  }) : super(parent: parent);

  /// The controller of [CustomScrollPhysics], it is mutable and will influence the
  /// physics of [Scrollable] dynamically.
  final CustomScrollPhysicsController? controller;

  /// Finds and returns the [CustomScrollPhysics] from [ScrollPhysics]'s parents.
  static CustomScrollPhysics? findInPhysics(ScrollPhysics? physics) {
    ScrollPhysics? currPhysics = physics;
    CustomScrollPhysics? result;
    while (currPhysics != null && currPhysics is! CustomScrollPhysics) {
      currPhysics = currPhysics.parent;
    }
    if (currPhysics != null && currPhysics is CustomScrollPhysics) {
      result = currPhysics;
    }
    return result;
  }

  /// Returns the [CustomScrollPhysics] from [Scrollable] widget most closely associated
  /// with the given context.
  static CustomScrollPhysics? findInAncestors(BuildContext context) {
    final scrollable = context.findAncestorWidgetOfExactType<Scrollable>();
    return findInPhysics(scrollable?.physics);
  }

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

    // merge current controller with parent controller
    var parentController = parent is! CustomScrollPhysics ? null : (parent as CustomScrollPhysics).controller;
    var disableScrollMore = (parentController?.disableScrollMore ?? false) || controller!.disableScrollMore;
    var disableScrollLess = (parentController?.disableScrollLess ?? false) || controller!.disableScrollLess;

    // apply boundary condition using current flags
    final lastScrollValue = controller!._lastScrollValue;
    if (lastScrollValue != null) {
      if (value > lastScrollValue && disableScrollMore) {
        // value turns larger => scroll more
        return value - position.pixels;
      }
      if (value < lastScrollValue && disableScrollLess) {
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

  @override
  String toString() {
    return 'CustomScrollPhysicsController(disableScrollMore: $disableScrollMore, disableScrollLess: $disableScrollLess)';
  }
}

/// An inherited widget that associates an [ScrollPhysics] with a subtree.
class DefaultScrollPhysics extends InheritedWidget {
  const DefaultScrollPhysics({
    Key? key,
    required this.physics,
    required Widget child,
  }) : super(key: key, child: child);

  /// The data associated with the subtree.
  final ScrollPhysics physics;

  /// Returns the data most closely associated with the given context.
  static ScrollPhysics? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<DefaultScrollPhysics>();
    return result?.physics;
  }

  @override
  bool updateShouldNotify(DefaultScrollPhysics oldWidget) {
    return physics != oldWidget.physics;
  }
}
