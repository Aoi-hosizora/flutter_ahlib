import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/util/flutter_extension.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/scrollbar_with_more.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// The duration for refreshing list after clearing the data.
const _kFlashListDuration = Duration(milliseconds: 50);

/// The duration for fake refreshing when nothing.
const _kFakeRefreshDuration = Duration(milliseconds: 250);

/// A data model for [PaginationDataView], represents the returned data.
class PagedList<T> {
  const PagedList({
    required this.list,
    required this.next,
  });

  /// The list data.
  final List<T> list;

  /// The next indicator for pagination.
  final dynamic next;
}

/// A list of pagination settings for [PaginationDataView].
class PaginationSetting {
  const PaginationSetting({
    this.initialIndicator = 1,
    this.nothingIndicator,
    this.currentIndicator,
    this.currentNextIndicator,
  }) : assert(initialIndicator != null);

  /// The initial indicator for pagination, default to 1 and must not be null. Note that if you are
  /// using seek based pagination strategy, it is necessary to set this value to your own.
  final dynamic initialIndicator;

  /// The indicator which means there is no data at following page, defaults to null for no check.
  /// Note that this checking will have no effect when resetting or refreshing the data view.
  final dynamic nothingIndicator;

  /// The current indicator for pagination, default to [initialIndicator], and this option will be
  /// used to append data (not reset or refresh) only when given data is not empty.
  final dynamic currentIndicator;

  /// The current next indicator for pagination, default to [currentIndicator] + 1, and this option
  /// will be used to append data (not reset or refresh) only when given data is not empty.
  final dynamic currentNextIndicator;
}

/// An implementation of [UpdatableDataView] for pagination data, including [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar]
/// and some scroll view, such as [ListView], [SliverList] with [CustomScrollView], [MasonryGridView], [SliverMasonryGrid] with [CustomScrollView].
class PaginationDataView<T> extends UpdatableDataView<T> {
  const PaginationDataView({
    Key? key,
    required this.data,
    required this.style,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  }) : super(key: key);

  const PaginationDataView.listView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
  })  : style = UpdatableDataViewStyle.listView,
        useOverlapInjector = null,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        super(key: key);

  const PaginationDataView.sliverListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
  })  : style = UpdatableDataViewStyle.sliverListView,
        crossAxisCount = null,
        mainAxisSpacing = null,
        crossAxisSpacing = null,
        super(key: key);

  const PaginationDataView.masonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  })  : style = UpdatableDataViewStyle.masonryGridView,
        separator = null,
        useOverlapInjector = null,
        super(key: key);

  const PaginationDataView.sliverMasonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    this.useOverlapInjector = false,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  })  : style = UpdatableDataViewStyle.sliverMasonryGridView,
        separator = null,
        super(key: key);

  // General properties

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  final Future<PagedList<T>> Function({required dynamic indicator}) getData;

  /// The data display style.
  @override
  final UpdatableDataViewStyle style;

  /// The pagination setting.
  final PaginationSetting paginationSetting;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The controller for [ScrollView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [ScrollView].
  @override
  final Widget Function(BuildContext, int, T) itemBuilder;

  /// The extra widgets around [ScrollView].
  @override
  final UpdatableDataViewExtraWidgets? extra;

  // Properties for specific data display style

  /// The separator for [ListView] and [SliverList].
  final Widget? separator;

  /// The switcher to use [SliverOverlapInjector] in the top of sliver list for [SliverList], defaults to false.
  final bool? useOverlapInjector;

  /// The crossAxisCount for [MasonryGridView] and [SliverMasonryGrid], defaults to 2.
  final int? crossAxisCount;

  /// The mainAxisSpacing for [MasonryGridView] and [SliverMasonryGrid], defaults to 0.0.
  final double? mainAxisSpacing;

  /// The crossAxisSpacing for [MasonryGridView] and [SliverMasonryGrid], defaults to 0.0.
  final double? crossAxisSpacing;

  @override
  PaginationDataViewState<T> createState() => PaginationDataViewState<T>();
}

/// The state of [PaginationDataView], can be used to get the pagination indicator by [currentIndicator] and [nextIndicator] readonly properties,
/// or show the append or refresh indicator by [append] and [refresh] method.
class PaginationDataViewState<T> extends State<PaginationDataView<T>> with AutomaticKeepAliveClientMixin<PaginationDataView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  var _downScrollable = false;
  dynamic _currentIndicator;
  dynamic _nextIndicator;

  /// Returns the current pagination indicator of the current list data.
  dynamic get currentIndicator => _currentIndicator;

  /// Returns the next pagination indicator of the current list data.
  dynamic get nextIndicator => _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    if (widget.data.isNotEmpty) {
      _currentIndicator = widget.paginationSetting.currentIndicator ?? widget.paginationSetting.initialIndicator;
      _nextIndicator = widget.paginationSetting.currentNextIndicator ?? (_currentIndicator + 1);
    }
  }

  /// Shows the append indicator and runs the append callback as if it had been started interactively.
  Future<void> append() {
    return _appendIndicatorKey.currentState?.show() ?? Future.value();
  }

  /// Shows the refresh indicator and runs the refresh callback as if it had been started interactively.
  Future<void> refresh() {
    return _refreshIndicatorKey.currentState?.show() ?? Future.value();
  }

  bool _onScroll(ScrollNotification s) {
    _downScrollable = !s.metrics.isShortScrollArea() && s.metrics.isInBottom();
    return false;
  }

  Future<void> _getData({required bool reset}) async {
    // start loading
    _forceState = null;
    if (reset || _nextIndicator == null) {
      _nextIndicator = widget.paginationSetting.initialIndicator; // current indicator
    }
    _loading = true;
    _errorMessage = '';
    if (reset) {
      if (widget.setting.clearWhenRefresh ?? false) {
        widget.data.clear();
      }
      widget.setting.onStartRefreshing?.call(); // start refreshing
    }
    widget.setting.onStartGettingData?.call(); // start loading
    if (mounted) setState(() {});

    // handle nothing directly
    if (!reset && _nextIndicator == widget.paginationSetting.nothingIndicator) {
      return Future.delayed(_kFakeRefreshDuration).then((_) {
        _loading = false;
        _errorMessage = '';
        _currentIndicator = _nextIndicator;
        widget.setting.onAppend?.call(_nextIndicator, []);
        widget.setting.onStopGettingData?.call(); // stop loading callback
        if (reset) {
          widget.setting.onStopRefreshing?.call(); // stop refreshing callback
        }
        if (mounted) setState(() {});
      });
    }

    // get data
    final func = widget.getData(indicator: _nextIndicator); // Future<PagedList<T>>

    // return future
    return func.then((PagedList<T> list) async {
      // success to get data without error
      _errorMessage = '';
      if (list.list.isEmpty && (widget.setting.updateOnlyIfNotEmpty ?? false)) {
        // got an empty list, nothing changed
        _currentIndicator = _nextIndicator;
        widget.setting.onAppend?.call(_nextIndicator, []);
        return;
      }
      // replace or append
      if (reset) {
        if (widget.data.isNotEmpty) {
          widget.data.clear();
          if (mounted) setState(() {});
          await Future.delayed(_kFlashListDuration);
        }
        widget.data.addAll(list.list);
      } else {
        widget.data.addAll(list.list);
        if (_downScrollable) {
          widget.scrollController?.scrollDown();
        }
      }
      _currentIndicator = _nextIndicator;
      widget.setting.onAppend?.call(_nextIndicator, list.list);
      _nextIndicator = list.next;
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
      widget.setting.onStopGettingData?.call(); // stop loading callback
      if (reset) {
        widget.setting.onStopRefreshing?.call(); // stop refreshing callback
      }
      if (mounted) setState(() {});
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
        return const SizedBox(height: 0);
      } else if (idx < tl + dl - 1) {
        return widget.separator ?? const SizedBox(height: 0);
      } else {
        return const SizedBox(height: 0);
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
        controller: widget.scrollController,
        padding: widget.setting.padding,
        physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
        reverse: widget.setting.reverse ?? false,
        shrinkWrap: widget.setting.shrinkWrap ?? false,
        // ===================================
        separatorBuilder: separatorBuilder,
        itemCount: tl + dl + bl,
        itemBuilder: itemBuilder,
      );
    }

    return CustomScrollView(
      controller: widget.scrollController,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
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

  Widget _buildMasonryGridView(BuildContext context, bool sliver) {
    if (!sliver) {
      return MasonryGridView.count(
        controller: widget.scrollController,
        padding: widget.setting.padding,
        physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
        reverse: widget.setting.reverse ?? false,
        shrinkWrap: widget.setting.shrinkWrap ?? false,
        // ===================================
        crossAxisCount: widget.crossAxisCount ?? 2,
        mainAxisSpacing: widget.mainAxisSpacing ?? 0.0,
        crossAxisSpacing: widget.crossAxisSpacing ?? 0.0,
        itemCount: widget.data.length,
        itemBuilder: (c, idx) => widget.itemBuilder(c, idx, widget.data[idx]), // ignore extra listTopWidgets and listBottomWidgets
      );
    }

    return CustomScrollView(
      controller: widget.scrollController,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget view;
    switch (widget.style) {
      case UpdatableDataViewStyle.listView:
        view = _buildListView(context, false);
        break;
      case UpdatableDataViewStyle.sliverListView:
        view = _buildListView(context, true);
        break;
      case UpdatableDataViewStyle.masonryGridView:
        view = _buildMasonryGridView(context, false);
        break;
      case UpdatableDataViewStyle.sliverMasonryGridView:
        view = _buildMasonryGridView(context, true);
        break;
    }

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      color: widget.setting.appendIndicatorColor,
      backgroundColor: widget.setting.appendIndicatorBackgroundColor,
      minHeight: widget.setting.appendIndicatorMinHeight,
      notificationPredicate: widget.setting.appendNotificationPredicate ?? defaultScrollNotificationPredicate,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
        color: widget.setting.refreshIndicatorColor,
        backgroundColor: widget.setting.refreshIndicatorBackgroundColor,
        displacement: widget.setting.refreshIndicatorDisplacement ?? 40.0,
        strokeWidth: widget.setting.refreshIndicatorStrokeWidth ?? RefreshProgressIndicator.defaultStrokeWidth,
        notificationPredicate: widget.setting.refreshNotificationPredicate ?? defaultScrollNotificationPredicate,
        child: Column(
          crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (widget.extra?.outerTopWidgets != null) ...(widget.extra?.outerTopWidgets)!,
            Expanded(
              child: PlaceholderText.from(
                onRefresh: () => _refreshIndicatorKey.currentState?.show(),
                forceState: _forceState,
                isLoading: _loading,
                isEmpty: widget.data.isEmpty,
                errorText: _errorMessage,
                onChanged: widget.setting.onPlaceholderStateChanged,
                setting: widget.setting.placeholderSetting ?? const PlaceholderSetting(),
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidgets != null) ...(widget.extra?.innerTopWidgets)!,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.scrollbar ?? true
                            ? ScrollbarWithMore(
                                interactive: widget.setting.interactiveScrollbar ?? false,
                                isAlwaysShown: widget.setting.alwaysShowScrollbar ?? false,
                                radius: widget.setting.scrollbarRadius,
                                thickness: widget.setting.scrollbarThickness,
                                mainAxisMargin: widget.setting.scrollbarMainAxisMargin,
                                crossAxisMargin: widget.setting.scrollbarCrossAxisMargin,
                                controller: widget.scrollController,
                                child: view,
                              )
                            : view,
                      ),
                    ),
                    if (widget.extra?.innerBottomWidgets != null) ...(widget.extra?.innerBottomWidgets)!,
                  ],
                ),
              ),
            ),
            if (widget.extra?.outerBottomWidgets != null) ...(widget.extra?.outerBottomWidgets)!,
          ],
        ),
      ),
    );
  }
}

/// An implementation of [PaginationDataView], which displays data in [ListView], only for backward compatibility.
class PaginationListView<T> extends PaginationDataView<T> {
  /// This constructor is the same as [PaginationDataView.listView], only for backward compatibility.
  const PaginationListView({
    Key? key,
    required List<T> data,
    required Future<PagedList<T>> Function({required dynamic indicator}) getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    PaginationSetting paginationSetting = const PaginationSetting(),
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
          paginationSetting: paginationSetting,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          separator: separator,
        );
}

/// An implementation of [PaginationDataView], which displays data in [SliverList] with [CustomScrollView], only for backward compatibility.
class PaginationSliverListView<T> extends PaginationDataView<T> {
  /// This constructor is the same as [PaginationDataView.sliverListView], only for backward compatibility.
  const PaginationSliverListView({
    Key? key,
    required List<T> data,
    required Future<PagedList<T>> Function({required dynamic indicator}) getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    PaginationSetting paginationSetting = const PaginationSetting(),
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
          paginationSetting: paginationSetting,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          separator: separator,
          useOverlapInjector: useOverlapInjector,
        );
}

/// An implementation of [PaginationDataView], which displays data in [MasonryGridView], only for backward compatibility.
class PaginationMasonryGridView<T> extends PaginationDataView<T> {
  /// This constructor is the same as [PaginationDataView.masonryGridView], only for backward compatibility.
  const PaginationMasonryGridView({
    Key? key,
    required List<T> data,
    required Future<PagedList<T>> Function({required dynamic indicator}) getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    PaginationSetting paginationSetting = const PaginationSetting(),
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
          paginationSetting: paginationSetting,
          scrollController: scrollController,
          itemBuilder: itemBuilder,
          extra: extra,
          // ===================================
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        );
}

/// An implementation of [PaginationDataView], which displays data in [MasonryGridView] with [CustomScrollView], only for backward compatibility.
class PaginationSliverMasonryGridView<T> extends PaginationDataView<T> {
  /// This constructor is the same as [PaginationDataView.sliverMasonryGridView], only for backward compatibility.
  const PaginationSliverMasonryGridView({
    Key? key,
    required List<T> data,
    required Future<PagedList<T>> Function({required dynamic indicator}) getData,
    UpdatableDataViewSetting<T> setting = const UpdatableDataViewSetting(),
    PaginationSetting paginationSetting = const PaginationSetting(),
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
          paginationSetting: paginationSetting,
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
