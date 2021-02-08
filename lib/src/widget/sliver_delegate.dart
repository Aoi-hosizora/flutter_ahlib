import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

// ==============
// AppBar related
// ==============

/// An implementation of [SliverPersistentHeaderDelegate] with a [PreferredSize] child.
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const SliverAppBarDelegate({
    @required this.child,
  }) : assert(child != null);

  /// The preferred sized child of this widget.
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
  })  : assert(minHeight != null && maxHeight != null && minHeight <= maxHeight),
        assert(child != null);

  /// The minimum height of this widget.
  final double minHeight;

  /// The maximum height of this widget.
  final double maxHeight;

  /// The child of this widget.
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

// =================
// separator related
// =================

/// A custom [SliverChildListDelegate] (implementation of [SliverChildDelegate]) with separator.
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

/// A custom [SliverChildBuilderDelegate] (implementation of [SliverChildDelegate]) with separator builder.
class SliverSeparatedListBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatedListBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    int childCount,
    @required Widget Function(BuildContext, int) separatorBuilder,
  })  : assert(builder != null),
        assert(separatorBuilder != null),
        super(
          (c, idx) => idx % 2 != 0 ? separatorBuilder.call(c, idx ~/ 2) : builder.call(c, idx ~/ 2),
          childCount: childCount * 2 - 1,
        );
}
