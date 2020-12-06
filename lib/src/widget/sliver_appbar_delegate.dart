import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [SliverAppBarDelegate] is an implementation of [SliverPersistentHeaderDelegate] with a [PreferredSize] child.
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const SliverAppBarDelegate({
    @required this.child,
  }) : assert(child != null);

  final PreferredSize child;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

/// [SliverAppBarSizedDelegate] is an implementation of [SliverPersistentHeaderDelegate] with size setting and a child.
class SliverAppBarSizedDelegate extends SliverPersistentHeaderDelegate {
  const SliverAppBarSizedDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  }) : assert(minHeight != null),
       assert(maxHeight != null),
       assert(child != null);

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarSizedDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

