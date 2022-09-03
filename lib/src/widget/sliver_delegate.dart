import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

// ==============
// Header related
// ==============

// ignore_for_file: prefer_initializing_formals

/// An implementation of [SliverPersistentHeaderDelegate] with [PreferredSizeWidget] child with size settings,
/// can be used in [SliverPersistentHeader]..
class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Creates [SliverHeaderDelegate] with given [PreferredSizeWidget].
  const SliverHeaderDelegate({
    required PreferredSizeWidget child,
    this.minHeight,
    this.maxHeight,
  })  : builder = null,
        child = child;

  /// Creates [SliverHeaderDelegate] with given [PreferredSizeWidget] builder and required size settings.
  const SliverHeaderDelegate.builder({
    required PreferredSizeWidget Function(BuildContext context, double shrinkOffset, bool overlapsContent) builder,
    required double minHeight,
    required double maxHeight,
  })  : child = null,
        builder = builder,
        minHeight = minHeight,
        maxHeight = maxHeight;

  /// The preferred sized child of this widget.
  final PreferredSizeWidget? child;

  /// The preferred sized child builder of this widget.
  final PreferredSizeWidget Function(BuildContext context, double shrinkOffset, bool overlapsContent)? builder;

  /// The minimum height of this widget, defaults to [child.preferredSize.height].
  final double? minHeight;

  /// The maximum height of this widget, defaults to [child.preferredSize.height].
  final double? maxHeight;

  @override
  double get minExtent => child != null ? (minHeight ?? child!.preferredSize.height) : minHeight!;

  @override
  double get maxExtent => child != null ? (maxHeight ?? child!.preferredSize.height) : maxHeight!;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (child != null) {
      return child!;
    }
    return builder!(context, shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(covariant SliverHeaderDelegate oldDelegate) {
    if (builder != null) {
      return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || builder != oldDelegate.builder; // almost true because of function comparison
    }
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

// =================
// separator related
// =================

/// A [SemanticIndexCallback] which is used when [addSemanticIndexes] is true, defaults to providing an index
/// for each widget.
int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// An implementation of [SliverChildListDelegate] and SliverChildDelegate, with separator widget.
class SliverSeparatedListDelegate extends SliverChildListDelegate {
  SliverSeparatedListDelegate(
    List<Widget> children, {
    required Widget separator,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          children.separate(separator),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );

  SliverSeparatedListDelegate.fixed(
    List<Widget> children, {
    required Widget separator,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super.fixed(
          children.separate(separator),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );
}

/// An implementation of [SliverChildListDelegate] and SliverChildDelegate, with separator builder.
class SliverSeparatedListBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatedListBuilderDelegate(
    NullableIndexedWidgetBuilder builder, {
    required int childCount,
    required Widget? Function(BuildContext, int) separatorBuilder,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback = _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          (c, idx) => idx % 2 == 0 ? builder.call(c, idx ~/ 2) : separatorBuilder.call(c, idx ~/ 2),
          childCount: childCount * 2 - 1,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );
}
