// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Note: This file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
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
    this.onPageMetricsChanged,
    this.callPageChangedAtEnd = true,
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
    this.onPageMetricsChanged,
    this.callPageChangedAtEnd = true,
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

  /// The callback that will be invoked when [PageMetrics] changed, and [callPageChangedAtEnd]
  /// has no influence on this callback.
  final ValueChanged<PageMetrics>? onPageMetricsChanged;

  /// The flag to call [onPageChanged] when page changing is finished, defaults to true, and this
  /// means it will behave the same as builtin [PageView].
  final bool callPageChangedAtEnd;

  /// A double value that represents the hint size at page main axis, is used to set the cache
  /// extent for preloading page, defaults to `MediaQuery.of(context).size`.
  final double? pageMainAxisHintSize;

  /// An integer value that determines number pages that will be preloaded,defaults to 0.
  final int preloadPagesCount;

  @override
  State<PreloadablePageView> createState() => _PreloadablePageViewState();
}

class _PreloadablePageViewState extends State<PreloadablePageView> {
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
    final pageMainAxisHintSize = widget.pageMainAxisHintSize ?? // <<< Added by AoiHosizora
        (widget.scrollDirection == Axis.horizontal ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height);

    return PageChangedListener(
      initialPage: widget.controller.initialPage,
      onPageChanged: widget.onPageChanged,
      onPageMetricsChanged: widget.onPageMetricsChanged,
      callPageChangedAtEnd: widget.callPageChangedAtEnd /* <<< Modified by AoiHosizora */,
      child: Scrollable(
        dragStartBehavior: widget.dragStartBehavior,
        axisDirection: axisDirection,
        controller: widget.controller,
        physics: physics,
        restorationId: widget.restorationId,
        scrollBehavior: widget.scrollBehavior ?? ScrollConfiguration.of(context).copyWith(scrollbars: false),
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Viewport(
            cacheExtent: widget.preloadPagesCount < 1 ? 0 : pageMainAxisHintSize * widget.preloadPagesCount - 1 /* <<< Modified by AoiHosizora */,
            cacheExtentStyle: CacheExtentStyle.pixel /* <<< Modified by AoiHosizora */,
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

/// A widget which wraps [NotificationListener] for [PageView] or [TabBarView], to overwrite the
/// behavior of these widgets' [onPageChanged] callback.
class PageChangedListener extends StatefulWidget {
  const PageChangedListener({
    Key? key,
    required this.child,
    this.initialPage,
    this.onPageChanged,
    this.onPageMetricsChanged,
    this.callPageChangedAtEnd = true,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The initial page value which is used to initialize the last reported page only for checking
  /// [onPageChanged]. It is suggested to initialize to [PageController.initialPage], defaults to 0.
  final int? initialPage;

  /// The callback that will be invoked when the current page changed, and its invoking timing
  /// also depends on [callPageChangedAtEnd].
  final ValueChanged<int>? onPageChanged;

  /// The callback that will be invoked when [PageMetrics] changed, and [callPageChangedAtEnd]
  /// has no influence on this callback.
  final ValueChanged<PageMetrics>? onPageMetricsChanged;

  /// The flag to call [onPageChanged] when page changing is finished, defaults to true, and this
  /// means it will behave the same as builtin [PageView].
  ///
  /// Note that this flag has no influence to listeners in [PageController], those will still be
  /// called when round value of page offset changed.
  final bool callPageChangedAtEnd;

  @override
  State<PageChangedListener> createState() => _PageChangedListenerState();
}

class _PageChangedListenerState extends State<PageChangedListener> {
  late int _lastReportedPage = widget.initialPage ?? 0;

  void _onNotification(ScrollNotification notification) {
    // check parameters
    if (notification.depth != 0 || widget.onPageChanged == null) {
      return;
    }

    // get PageMetrics
    if (notification.metrics is! PageMetrics) {
      return;
    }
    final PageMetrics metrics = notification.metrics as PageMetrics;
    widget.onPageMetricsChanged?.call(metrics);

    // get page int value
    if (!widget.callPageChangedAtEnd && notification is ScrollUpdateNotification) {
      // continue
    } else if (widget.callPageChangedAtEnd && notification is ScrollEndNotification) {
      // continue
    } else {
      return;
    }

    // check current page equality
    int currentPage = metrics.page!.round();
    if (currentPage != _lastReportedPage) {
      _lastReportedPage = currentPage;
      widget.onPageChanged!(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _onNotification(notification);
        return false;
      },
      child: widget.child,
    );
  }
}
