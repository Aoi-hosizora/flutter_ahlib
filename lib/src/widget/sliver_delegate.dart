import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/dart_extensions.dart';

/// An implementation of [SliverPersistentHeaderDelegate] with a [PreferredSize] child.
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

/// An implementation of [SliverPersistentHeaderDelegate] with size setting and a [Widget] child.
class SliverAppBarSizedDelegate extends SliverPersistentHeaderDelegate {
  const SliverAppBarSizedDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  })  : assert(minHeight != null),
        assert(maxHeight != null),
        assert(minHeight <= maxHeight),
        assert(child != null);

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarSizedDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

/// A custom [SliverChildBuilderDelegate] with separator, notice that this class has not a const constructor.
class SliverSeparatedBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatedBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    @required Widget separator,
    int childCount,
  })  : assert(builder != null),
        assert(separator != null),
        super(
          (c, idx) => idx % 2 != 0 ? separator : builder.call(c, idx ~/ 2),
          childCount: childCount * 2 - 1,
        );
}

/// A custom [SliverChildListDelegate] with separator, notice that this class has not a const constructor.
class SliverSeparatedListDelegate extends SliverChildListDelegate {
  SliverSeparatedListDelegate(
    List<Widget> children, {
    @required Widget separator,
  })  : assert(children != null),
        assert(separator != null),
        super(
          children.separate(separator),
        );
}
