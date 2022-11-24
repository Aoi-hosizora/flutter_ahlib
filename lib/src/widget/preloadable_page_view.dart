// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Note: The file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - PageView: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/widgets/page_view.dart

// Having this global (mutable) page controller is a bit of a hack. We need it
// to plumb in the factory for _PagePosition, but it will end up accumulating
// a large list of scroll positions. As long as you don't try to actually
// control the scroll positions, everything should be fine.
final PageController _defaultPageController = PageController(); // <<< the same as Flutter's source code
const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

/// A scrollable and preloadable list that works page by page, which is modified from [PageView].
class PreloadablePageView extends StatefulWidget {
  /// Creates a scrollable list that works page by page from an explicit [List] of widgets.
  PreloadablePageView({
    Key? key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    PageController? controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    List<Widget> children = const <Widget>[],
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padEnds = true,
    this.changePageWhenFinished = false,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : assert(pageMainAxisHintSize == null || pageMainAxisHintSize >= 0),
        assert(preloadPagesCount >= 0),
        controller = controller ?? _defaultPageController,
        childrenDelegate = SliverChildListDelegate(children),
        super(key: key);

  /// Creates a scrollable list that works page by page using widgets that are created on demand.
  PreloadablePageView.builder({
    Key? key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    PageController? controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    required IndexedWidgetBuilder itemBuilder,
    int? itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehavior,
    this.padEnds = true,
    this.changePageWhenFinished = false,
    this.pageMainAxisHintSize,
    this.preloadPagesCount = 0,
  })  : assert(pageMainAxisHintSize == null || pageMainAxisHintSize >= 0),
        assert(preloadPagesCount >= 0),
        controller = controller ?? _defaultPageController,
        childrenDelegate = SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
        super(key: key);

  /// Mirrors to [PageView.restorationId].
  final String? restorationId;

  /// Mirrors to [PageView.scrollDirection].
  final Axis scrollDirection;

  /// Mirrors to [PageView.reverse].
  final bool reverse;

  /// Mirrors to [PageView.controller].
  final PageController controller;

  /// Mirrors to [PageView.physics].
  final ScrollPhysics? physics;

  /// Mirrors to [PageView.pageSnapping].
  final bool pageSnapping;

  /// Mirrors to [PageView.onPageChanged].
  final ValueChanged<int>? onPageChanged;

  /// Mirrors to [PageView.childrenDelegate].
  final SliverChildDelegate childrenDelegate;

  /// Mirrors to [PageView.dragStartBehavior].
  final DragStartBehavior dragStartBehavior;

  /// Mirrors to [PageView.clipBehavior].
  final Clip clipBehavior;

  /// Mirrors to [PageView.scrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Mirrors to [PageView.padEnds].
  final bool padEnds;

  // extended

  /// The flag to call [onPageChanged] when page changing is finished. Note that listeners in
  /// [PageController] will still be called when round value of page offset changed.
  final bool changePageWhenFinished;

  /// A double value that represents the hint size at page main axis, is used to set the cache
  /// extent for preloading page, defaults to `MediaQuery.of(context).size`.
  final double? pageMainAxisHintSize;

  /// An integer value that determines number pages that will be preloaded,defaults to 0.
  final int preloadPagesCount;

  @override
  State<PreloadablePageView> createState() => _PreloadablePageViewState();
}

class _PreloadablePageViewState extends State<PreloadablePageView> {
  int _lastReportedPage = 0;

  @override
  void initState() {
    super.initState();
    _lastReportedPage = widget.controller.initialPage;
  }

  AxisDirection _getDirection(BuildContext context) {
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        assert(debugCheckHasDirectionality(context));
        final TextDirection textDirection = Directionality.of(context);
        final AxisDirection axisDirection = textDirectionToAxisDirection(textDirection);
        return widget.reverse ? flipAxisDirection(axisDirection) : axisDirection;
      case Axis.vertical:
        return widget.reverse ? AxisDirection.up : AxisDirection.down;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AxisDirection axisDirection = _getDirection(context);
    final ScrollPhysics? physics = widget.pageSnapping
        ? _kPagePhysics.applyTo(widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context)) //
        : widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context);
    final pageMainAxisHintSize = widget.pageMainAxisHintSize ?? //
        (widget.scrollDirection == Axis.horizontal ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0 && widget.onPageChanged != null) {
          if ((!widget.changePageWhenFinished && notification is ScrollUpdateNotification) || //
              (widget.changePageWhenFinished && notification is ScrollEndNotification)) {
            final PageMetrics metrics = notification.metrics as PageMetrics;
            final int currentPage = metrics.page!.round();
            if (currentPage != _lastReportedPage) {
              _lastReportedPage = currentPage;
              widget.onPageChanged!(currentPage);
            }
          }
        }
        return false;
      },
      child: Scrollable(
        dragStartBehavior: widget.dragStartBehavior,
        axisDirection: axisDirection,
        controller: widget.controller,
        physics: physics,
        restorationId: widget.restorationId,
        scrollBehavior: widget.scrollBehavior ?? ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Viewport(
            cacheExtent: widget.preloadPagesCount < 1 ? 0 : pageMainAxisHintSize * widget.preloadPagesCount - 1,
            cacheExtentStyle: CacheExtentStyle.pixel,
            // cacheExtent: widget.allowImplicitScrolling ? 1.0 : 0.0,
            // cacheExtentStyle: CacheExtentStyle.viewport,
            axisDirection: axisDirection,
            offset: position,
            clipBehavior: widget.clipBehavior,
            slivers: <Widget>[
              SliverFillViewport(
                viewportFraction: widget.controller.viewportFraction,
                delegate: widget.childrenDelegate,
                padEnds: widget.padEnds,
              ),
            ],
          );
        },
      ),
    );
  }
}
