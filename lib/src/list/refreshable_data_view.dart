import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_data_view.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/extended_scrollbar.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// An implementation of [UpdatableDataView] for refreshable data, including [RefreshIndicator], [PlaceholderText], [Scrollbar] and some
/// scroll views, such as [ListView], [SliverList] with [CustomScrollView], [MasonryGridView], [SliverMasonryGrid] with [CustomScrollView].
class RefreshableDataView<T> extends UpdatableDataView<T> {
  /// Creates a [RefreshableDataView] with given [style] and all properties.
  const RefreshableDataView({
    Key? key,
    required this.data,
    required this.style,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.onStyleChanged,
    this.extra,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
    this.gridDelegate,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.customViewBuilder,
  }) : super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.listView].
  const RefreshableDataView.listView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
  })  : style = UpdatableDataViewStyle.listView,
        onStyleChanged = null,
        useOverlapInjector = null,
        gridDelegate = null,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.sliverListView].
  const RefreshableDataView.sliverListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
  })  : style = UpdatableDataViewStyle.sliverListView,
        onStyleChanged = null,
        gridDelegate = null,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.gridView].
  const RefreshableDataView.gridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.gridDelegate,
  })  : style = UpdatableDataViewStyle.gridView,
        onStyleChanged = null,
        separator = null,
        useOverlapInjector = null,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.sliverGridView].
  const RefreshableDataView.sliverGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.useOverlapInjector = false,
    this.gridDelegate,
  })  : style = UpdatableDataViewStyle.sliverGridView,
        onStyleChanged = null,
        separator = null,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.masonryGridView].
  const RefreshableDataView.masonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  })  : style = UpdatableDataViewStyle.masonryGridView,
        onStyleChanged = null,
        separator = null,
        useOverlapInjector = null,
        gridDelegate = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.sliverMasonryGridView].
  const RefreshableDataView.sliverMasonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.useOverlapInjector = false,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  })  : style = UpdatableDataViewStyle.sliverMasonryGridView,
        onStyleChanged = null,
        separator = null,
        gridDelegate = null,
        customViewBuilder = null,
        super(key: key);

  /// Creates a [RefreshableDataView] with given [UpdatableDataViewStyle.customView].
  const RefreshableDataView.customView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.scrollViewKey,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
    this.gridDelegate,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    required this.customViewBuilder,
  })  : style = UpdatableDataViewStyle.customView,
        onStyleChanged = null,
        super(key: key);

  // General properties

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data. You can set this field to null to hide refresh indicator,
  /// and this means given [data] never be updated by this widget.
  final Future<List<T>> Function()? getData;

  /// The data display style.
  @override
  final UpdatableDataViewStyle style;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The key for [ScrollView].
  @override
  final Key? scrollViewKey;

  /// The controller for [ScrollView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [ScrollView].
  @override
  final Widget Function(BuildContext, int, T) itemBuilder;

  /// The callback function to be called when [style] is changed.
  @override
  final void Function(UpdatableDataViewStyle oldStyle, UpdatableDataViewStyle newStyle)? onStyleChanged;

  /// The extra widgets around [ScrollView].
  @override
  final UpdatableDataViewExtraWidgets? extra;

  // Properties for specific data display style

  /// The separator for [ListView] and [SliverList].
  final Widget? separator;

  /// The switcher to use [SliverOverlapInjector] in the top of sliver widgets, defaults to false.
  final bool? useOverlapInjector;

  /// The gridDelegate for [GridView] and [SliverGrid], defaults to `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)`.
  final SliverGridDelegate? gridDelegate;

  /// The crossAxisCount for [MasonryGridView] and [SliverMasonryGrid], defaults to 2.
  final int? crossAxisCount;

  /// The mainAxisSpacing for [MasonryGridView] and [SliverMasonryGrid], defaults to 0.0.
  final double? mainAxisSpacing;

  /// The crossAxisSpacing for [MasonryGridView] and [SliverMasonryGrid], defaults to 0.0.
  final double? crossAxisSpacing;

  /// The customViewBuilder for [UpdatableDataViewStyle.customView].
  final Widget Function(BuildContext context, RefreshableDataView<T> view)? customViewBuilder;

  @override
  RefreshableDataViewState<T> createState() => RefreshableDataViewState<T>();
}

/// The state of [RefreshableDataViewState], can be used to show the refresh indicator by [refresh] method.
class RefreshableDataViewState<T> extends State<RefreshableDataView<T>> with AutomaticKeepAliveClientMixin<RefreshableDataView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    } else {
      _forceState = widget.setting.initialForceState ?? //
          (widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal);
    }
  }

  @override
  void didUpdateWidget(covariant RefreshableDataView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) {
      widget.onStyleChanged?.call(oldWidget.style, widget.style);
    }
  }

  /// Shows the refresh indicator and runs the refresh callback as if it had been started interactively.
  Future<void> refresh() {
    return _refreshIndicatorKey.currentState?.show() ?? Future.value();
  }

  Future<void> _getData() async {
    // start loading
    _forceState = null;
    _loading = true;
    _errorMessage = '';
    if (widget.setting.clearWhenRefresh ?? false) {
      widget.data.clear();
    }
    widget.setting.onStartRefreshing?.call(); // start refreshing
    widget.setting.onStartGettingData?.call(); // start loading
    if (mounted) setState(() {});

    // get data
    final func = widget.getData!(); // Future<List<T>>

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      if (widget.data.isNotEmpty) {
        _forceState = PlaceholderState.loading;
        if (mounted) setState(() {});
        await ambiguate(WidgetsBinding.instance)?.endOfFrame;
        await Future.delayed(widget.setting.flashListDuration ?? kFlashListDuration);
        _forceState = null;
        widget.data.clear();
      }
      widget.data.addAll(list);
      widget.setting.onAppend?.call(null, list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
      if (widget.setting.clearWhenError ?? false) {
        widget.data.clear();
      }
      widget.setting.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      widget.setting.onStopGettingData?.call(); // stop loading
      widget.setting.onStopRefreshing?.call(); // stop refreshing
      if (mounted) setState(() {});
      widget.setting.onFinalSetState?.call(); // final setState
    });
  }

  @override
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  Widget _buildListView(BuildContext context, bool sliver) {
    var top = widget.extra?.listTopWidgets ?? [];
    var data = widget.data;
    var bottom = widget.extra?.listBottomWidgets ?? [];
    var tl = top.length, dl = data.length, bl = bottom.length;

    Widget separatorBuilder(BuildContext c, int idx) {
      if (idx < tl) {
        return const SizedBox.shrink();
      } else if (idx < tl + dl - 1) {
        return widget.separator ?? const SizedBox.shrink();
      } else {
        return const SizedBox.shrink();
      }
    }

    Widget itemBuilder(BuildContext c, int idx) {
      if (idx < tl) {
        return top[idx];
      } else if (idx < tl + dl) {
        return widget.itemBuilder(c, idx - tl, data[idx - tl]);
      } else {
        return bottom[idx - tl - dl];
      }
    }

    if (!sliver) {
      return ListView.separated(
        key: widget.scrollViewKey,
        controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
        padding: widget.setting.padding,
        physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
        reverse: widget.setting.reverse ?? false,
        shrinkWrap: widget.setting.shrinkWrap ?? false,
        cacheExtent: widget.setting.cacheExtent,
        dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
        keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        restorationId: widget.setting.restorationId,
        clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
        // ===================================
        separatorBuilder: separatorBuilder,
        itemCount: tl + dl + bl,
        itemBuilder: itemBuilder,
      );
    }

    return CustomScrollView(
      key: widget.scrollViewKey,
      controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
      cacheExtent: widget.setting.cacheExtent,
      dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
      keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: widget.setting.restorationId,
      clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
      // ===================================
      slivers: [
        if (widget.useOverlapInjector ?? false)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.extra?.listTopSlivers != null) ...(widget.extra?.listTopSlivers)!,
        SliverPadding(
          padding: widget.setting.padding ?? MediaQuery.maybeOf(context)?.padding.copyWith(top: 0, bottom: 0) ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverSeparatedListBuilderDelegate(
              itemBuilder,
              childCount: tl + dl + bl,
              separatorBuilder: separatorBuilder,
            ),
          ),
        ),
        if (widget.extra?.listBottomSlivers != null) ...(widget.extra?.listBottomSlivers)!,
      ],
    );
  }

  Widget _buildGridView(BuildContext context, bool sliver) {
    var gridDelegate = widget.gridDelegate ??
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        );

    if (!sliver) {
      return GridView.builder(
        key: widget.scrollViewKey,
        controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
        padding: widget.setting.padding,
        physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
        reverse: widget.setting.reverse ?? false,
        shrinkWrap: widget.setting.shrinkWrap ?? false,
        cacheExtent: widget.setting.cacheExtent,
        dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
        keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        restorationId: widget.setting.restorationId,
        clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
        // ===================================
        gridDelegate: gridDelegate,
        itemCount: widget.data.length,
        itemBuilder: (c, idx) => widget.itemBuilder(c, idx, widget.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
      );
    }

    return CustomScrollView(
      key: widget.scrollViewKey,
      controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
      cacheExtent: widget.setting.cacheExtent,
      dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
      keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: widget.setting.restorationId,
      clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
      // ===================================
      slivers: [
        if (widget.useOverlapInjector ?? false)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.extra?.listTopSlivers != null) ...(widget.extra?.listTopSlivers)!,
        SliverPadding(
          padding: widget.setting.padding ?? MediaQuery.maybeOf(context)?.padding.copyWith(top: 0, bottom: 0) ?? EdgeInsets.zero,
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, idx) => widget.itemBuilder(c, idx, widget.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
              childCount: widget.data.length,
            ),
            gridDelegate: gridDelegate,
          ),
        ),
        if (widget.extra?.listBottomSlivers != null) ...(widget.extra?.listBottomSlivers)!,
      ],
    );
  }

  Widget _buildMasonryGridView(BuildContext context, bool sliver) {
    if (!sliver) {
      return MasonryGridView.count(
        key: widget.scrollViewKey,
        controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
        padding: widget.setting.padding,
        physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
        reverse: widget.setting.reverse ?? false,
        shrinkWrap: widget.setting.shrinkWrap ?? false,
        cacheExtent: widget.setting.cacheExtent,
        dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
        keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        restorationId: widget.setting.restorationId,
        clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
        // ===================================
        crossAxisCount: widget.crossAxisCount ?? 2,
        mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
        crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
        itemCount: widget.data.length,
        itemBuilder: (c, idx) => widget.itemBuilder(c, idx, widget.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
      );
    }

    return CustomScrollView(
      key: widget.scrollViewKey,
      controller: PreviouslySwitchedWidget.isPrevious(context) ? null : widget.scrollController,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
      cacheExtent: widget.setting.cacheExtent,
      dragStartBehavior: widget.setting.dragStartBehavior ?? DragStartBehavior.start,
      keyboardDismissBehavior: widget.setting.keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
      restorationId: widget.setting.restorationId,
      clipBehavior: widget.setting.clipBehavior ?? Clip.hardEdge,
      // ===================================
      slivers: [
        if (widget.useOverlapInjector ?? false)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.extra?.listTopSlivers != null) ...(widget.extra?.listTopSlivers)!,
        SliverPadding(
          padding: widget.setting.padding ?? MediaQuery.maybeOf(context)?.padding.copyWith(top: 0, bottom: 0) ?? EdgeInsets.zero,
          sliver: SliverMasonryGrid.count(
            crossAxisCount: widget.crossAxisCount ?? 2,
            mainAxisSpacing: widget.mainAxisSpacing ?? 0,
            crossAxisSpacing: widget.crossAxisSpacing ?? 0,
            childCount: widget.data.length,
            itemBuilder: (c, idx) => widget.itemBuilder(c, idx, widget.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
          ),
        ),
        if (widget.extra?.listBottomSlivers != null) ...(widget.extra?.listBottomSlivers)!,
      ],
    );
  }

  Widget _buildCustomView(BuildContext context) {
    assert(
      widget.customViewBuilder != null,
      'customViewBuilder must not be null when using UpdatableDataViewStyle.customView',
    );

    return widget.customViewBuilder!.call(context, widget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildView(BuildContext context) {
      switch (widget.style) {
        case UpdatableDataViewStyle.listView:
          return _buildListView(context, false);
        case UpdatableDataViewStyle.sliverListView:
          return _buildListView(context, true);
        case UpdatableDataViewStyle.gridView:
          return _buildGridView(context, false);
        case UpdatableDataViewStyle.sliverGridView:
          return _buildGridView(context, true);
        case UpdatableDataViewStyle.masonryGridView:
          return _buildMasonryGridView(context, false);
        case UpdatableDataViewStyle.sliverMasonryGridView:
          return _buildMasonryGridView(context, true);
        case UpdatableDataViewStyle.customView:
          return _buildCustomView(context);
      }
    }

    final view = Column(
      crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        if (widget.extra?.outerTopWidgets != null) ...(widget.extra?.outerTopWidgets)!,
        Expanded(
          child: PlaceholderText.from(
            forceState: _forceState,
            isEmpty: widget.data.isEmpty,
            isLoading: _loading && widget.data.isEmpty,
            errorText: _errorMessage,
            onRefresh: () => _refreshIndicatorKey.currentState?.show(),
            onChanged: widget.setting.onPlaceholderStateChanged,
            setting: widget.setting.placeholderSetting ?? const PlaceholderSetting(),
            displayRule: widget.setting.placeholderDisplayRule ?? PlaceholderDisplayRule.dataFirst,
            childBuilder: (c) => Column(
              crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                if (widget.extra?.innerTopWidgets != null) ...(widget.extra?.innerTopWidgets)!,
                Expanded(
                  child: widget.setting.scrollbar ?? true
                      ? ExtendedScrollbar(
                          interactive: PreviouslySwitchedWidget.isPrevious(c) ? false : widget.setting.interactiveScrollbar ?? false,
                          isAlwaysShown: widget.setting.alwaysShowScrollbar ?? false,
                          radius: widget.setting.scrollbarRadius,
                          thickness: widget.setting.scrollbarThickness,
                          mainAxisMargin: widget.setting.scrollbarMainAxisMargin,
                          crossAxisMargin: widget.setting.scrollbarCrossAxisMargin,
                          extraMargin: widget.setting.scrollbarExtraMargin,
                          controller: PreviouslySwitchedWidget.isPrevious(c) ? null : widget.scrollController,
                          child: _buildView(c),
                        )
                      : _buildView(c),
                ),
                if (widget.extra?.innerBottomWidgets != null) ...(widget.extra?.innerBottomWidgets)!,
              ],
            ),
          ),
        ),
        if (widget.extra?.outerBottomWidgets != null) ...(widget.extra?.outerBottomWidgets)!,
      ],
    );

    if (widget.getData == null) {
      return view;
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      color: widget.setting.refreshIndicatorColor,
      backgroundColor: widget.setting.refreshIndicatorBackgroundColor,
      displacement: widget.setting.refreshIndicatorDisplacement ?? 40.0,
      strokeWidth: widget.setting.refreshIndicatorStrokeWidth ?? RefreshProgressIndicator.defaultStrokeWidth,
      notificationPredicate: widget.setting.refreshNotificationPredicate ?? defaultScrollNotificationPredicate,
      child: view,
    );
  }
}

/// An implementation of [RefreshableDataView], which displays data in [ListView], only for backward compatibility.
class RefreshableListView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.listView], only for backward compatibility.
  const RefreshableListView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    Widget? separator,
  }) : super.listView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          separator: separator,
        );
}

/// An implementation of [RefreshableDataView], which displays data in [SliverList] with [CustomScrollView], only for backward compatibility.
class RefreshableSliverListView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.sliverListView], only for backward compatibility.
  const RefreshableSliverListView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    Widget? separator,
    bool? useOverlapInjector = false,
  }) : super.sliverListView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          separator: separator,
          useOverlapInjector: useOverlapInjector,
        );
}

/// An implementation of [RefreshableDataView], which displays data in [GridView], only for backward compatibility.
class RefreshableGridView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.gridView], only for backward compatibility.
  const RefreshableGridView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    SliverGridDelegate? gridDelegate,
  }) : super.gridView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          gridDelegate: gridDelegate,
        );
}

/// An implementation of [RefreshableDataView], which displays data in [SliverGrid] with [CustomScrollView], only for backward compatibility.
class RefreshableSliverGridView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.sliverGridView], only for backward compatibility.
  const RefreshableSliverGridView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    bool? useOverlapInjector = false,
    SliverGridDelegate? gridDelegate,
  }) : super.sliverGridView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          useOverlapInjector: useOverlapInjector,
          gridDelegate: gridDelegate,
        );
}

/// An implementation of [RefreshableDataView], which displays data in [MasonryGridView], only for backward compatibility.
class RefreshableMasonryGridView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.masonryGridView], only for backward compatibility.
  const RefreshableMasonryGridView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    int? crossAxisCount = 2,
    double? mainAxisSpacing = 0.0,
    double? crossAxisSpacing = 0.0,
  }) : super.masonryGridView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        );
}

/// An implementation of [RefreshableDataView], which displays data in [SliverMasonryGrid] with [CustomScrollView], only for backward compatibility.
class RefreshableSliverMasonryGridView<T> extends RefreshableDataView<T> {
  /// This constructor is the same as [RefreshableDataView.sliverMasonryGridView], only for backward compatibility.
  const RefreshableSliverMasonryGridView({
    Key? key,
    required List<T> data,
    required Future<List<T>> Function()? getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    Key? scrollViewKey,
    ScrollController? scrollController,
    required Widget Function(BuildContext, int, T) itemBuilder,
    UpdatableDataViewExtraWidgets? extra,
    // ===================================
    bool? useOverlapInjector = false,
    int? crossAxisCount = 2,
    double? mainAxisSpacing = 0.0,
    double? crossAxisSpacing = 0.0,
  }) : super.sliverMasonryGridView(
          key: key,
          data: data,
          getData: getData,
          setting: setting,
          scrollViewKey: scrollViewKey,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          useOverlapInjector: useOverlapInjector,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        );
}
