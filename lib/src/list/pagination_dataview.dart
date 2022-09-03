import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/util/flutter_extension.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/scrollbar_with_more.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// The duration for flashing list after clear the data.
const _kFlashListDuration = Duration(milliseconds: 50);

/// The duration for fake refreshing when nothing.
const _kNothingRefreshDuration = Duration(milliseconds: 200);

/// An abstract [UpdatableDataView] for pagination data view, implements by [PaginationListView], [PaginationSliverListView], [PaginationMasonryGridView].
abstract class PaginationDataView<T> extends UpdatableDataView<T> {
  const PaginationDataView({Key? key}) : super(key: key);

  /// The function to get list data with pagination.
  Future<PagedList<T>> Function({required dynamic indicator}) get getData;

  /// The pagination setting.
  PaginationSetting get paginationSetting;
}

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
  }) : assert(initialIndicator != null);

  /// The initial indicator for pagination, default is 1 and not null. Notice that if you are
  /// using seek based pagination strategy, it is necessary to set this value to your own.
  final dynamic initialIndicator;

  /// The indicator which means there is no data at this page, default value is null for no check.
  /// Note that this checking will have no effect when resetting or refreshing the data view.
  final dynamic nothingIndicator;
}

/// A [PaginationDataView] with [ListView], includes [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar] and [ListView].
class PaginationListView<T> extends PaginationDataView<T> {
  const PaginationListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    this.separator,
    this.extra,
  }) : super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({required dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController? controller;

  /// The controller for [ListView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [ListView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator for [ListView].
  @override
  final Widget? separator;

  /// The extra widgets around [ListView].
  @override
  final UpdatableDataViewExtraWidgets? extra;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  var _downScrollable = false;
  dynamic _nextIndicator; // TODO expose to parent widget ???

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
    _nextIndicator = widget.paginationSetting.initialIndicator;
  }

  @override
  void dispose() {
    widget.controller?.detachAppend();
    widget.controller?.detachRefresh();
    super.dispose();
  }

  bool _onScroll(ScrollNotification s) {
    _downScrollable = !s.metrics.isShortScrollArea() && s.metrics.isInBottom();
    return false;
  }

  Future<void> _getData({required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
      paginationSetting: widget.paginationSetting,
      scrollController: widget.scrollController,
      doSetState: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var top = widget.extra?.listTopWidgets ?? [];
    var data = widget.data;
    var bottom = widget.extra?.listBottomWidgets ?? [];
    var tl = top.length, dl = data.length, bl = bottom.length;
    var view = ListView.separated(
      controller: widget.scrollController,
      padding: widget.setting.padding,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
      // ===================================
      separatorBuilder: (c, idx) {
        if (idx < tl) {
          return const SizedBox(height: 0);
        } else if (idx < tl + dl - 1) {
          return widget.separator ?? const SizedBox(height: 0);
        } else {
          return const SizedBox(height: 0);
        }
      },
      itemCount: tl + dl + bl,
      itemBuilder: (c, idx) {
        if (idx < tl) {
          return top[idx];
        } else if (idx < tl + dl) {
          return widget.itemBuilder(c, data[idx - tl]);
        } else {
          return bottom[idx - tl - dl];
        }
      },
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      notificationPredicate: widget.setting.appendNotificationPredicate ?? defaultScrollNotificationPredicate,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
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
                onChanged: widget.setting.onStateChanged,
                setting: widget.setting.placeholderSetting ?? const PlaceholderSetting(),
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidgets != null) ...(widget.extra?.innerTopWidgets)!,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar ?? true
                            ? ScrollbarWithMore(
                                interactive: widget.setting.scrollbarInteractive ?? false,
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

// TODO merge PaginationListView and PaginationSliverListView

// TODO GridView and SliverGrid ???

/// A [PaginationDataView] with [SliverList], includes [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar], [CustomScrollView] and [SliverList].
class PaginationSliverListView<T> extends PaginationDataView<T> {
  const PaginationSliverListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    this.separator,
    this.extra,
    // ===================================
    this.useOverlapInjector = false,
    this.overlapInjectorHeight = 0.0,
  }) : super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({required dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController? controller;

  /// The controller for [CustomScrollView], you have to wrap this widget with [Builder] and use [PrimaryScrollController.of] to get correct
  /// [ScrollController] from [NestedScrollView], JUST NOT TO use [NestedScrollView]'s scrollController directly.
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [SliverList].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator for [SliverList].
  @override
  final Widget? separator;

  /// The extra widgets around [SliverList].
  @override
  final UpdatableDataViewExtraWidgets? extra;

  /// The switcher to use [SliverOverlapInjector], defaults to false. This is useful when outer [NestedScrollView] use [SliverOverlapAbsorber],
  /// or you can manually set the padding in [UpdatableDataViewExtraWidgets] and just set this value to false. If set to true, you have to wrap
  /// this widget with [Builder] to get correct [SliverOverlapAbsorber] handler by [NestedScrollView.sliverOverlapAbsorberHandleFor].
  final bool? useOverlapInjector;

  /// The height of overlap injector, which is used to replace [SliverOverlapInjector] and set padding out of [CustomScrollView]. TODO
  final double? overlapInjectorHeight;

  @override
  _PaginationSliverListViewState<T> createState() => _PaginationSliverListViewState<T>();
}

class _PaginationSliverListViewState<T> extends State<PaginationSliverListView<T>> with AutomaticKeepAliveClientMixin<PaginationSliverListView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  var _downScrollable = false;
  dynamic _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
    _nextIndicator = widget.paginationSetting.initialIndicator;
  }

  @override
  void dispose() {
    widget.controller?.detachAppend();
    widget.controller?.detachRefresh();
    super.dispose();
  }

  bool _onScroll(ScrollNotification s) {
    _downScrollable = !s.metrics.isShortScrollArea() && s.metrics.isInBottom();
    return false;
  }

  Future<void> _getData({required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
      paginationSetting: widget.paginationSetting,
      scrollController: widget.scrollController,
      doSetState: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var top = widget.extra?.listTopWidgets ?? [];
    var data = widget.data;
    var bottom = widget.extra?.listBottomWidgets ?? [];
    var tl = top.length, dl = data.length, bl = bottom.length;
    var view = CustomScrollView(
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
        SliverPadding(
          padding: widget.setting.padding ?? MediaQuery.maybeOf(context)?.padding.copyWith(top: 0, bottom: 0) ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverSeparatedListBuilderDelegate(
              (c, idx) {
                if (idx < tl) {
                  return top[idx];
                } else if (idx < tl + dl) {
                  return widget.itemBuilder(c, data[idx - tl]);
                } else {
                  return bottom[idx - tl - dl];
                }
              },
              childCount: tl + dl + bl,
              separatorBuilder: (c, idx) {
                if (idx < tl) {
                  return const SizedBox(height: 0);
                } else if (idx < tl + dl - 1) {
                  return widget.separator ?? const SizedBox(height: 0);
                } else {
                  return const SizedBox(height: 0);
                }
              },
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(top: widget.overlapInjectorHeight ?? 0),
      child: AppendIndicator(
        key: _appendIndicatorKey,
        onAppend: () => _getData(reset: false),
        notificationPredicate: widget.setting.appendNotificationPredicate ?? defaultScrollNotificationPredicate,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => _getData(reset: true),
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
                  onChanged: widget.setting.onStateChanged,
                  setting: widget.setting.placeholderSetting ?? const PlaceholderSetting(),
                  childBuilder: (c) => Column(
                    crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                    children: [
                      if (widget.extra?.innerTopWidgets != null) ...(widget.extra?.innerTopWidgets)!,
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (s) => _onScroll(s),
                          child: widget.setting.showScrollbar ?? true
                              ? ScrollbarWithMore(
                                  interactive: widget.setting.scrollbarInteractive ?? false,
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
      ),
    );
  }
}

/// A [PaginationDataView] with [MasonryGridView], includes [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar] and [MasonryGridView].
class PaginationMasonryGridView<T> extends PaginationDataView<T> {
  const PaginationMasonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    this.extra,
    // ===================================
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  }) : super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({required dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController? controller;

  /// The controller for [MasonryGridView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [MasonryGridView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The dummy separator, which is not supported by [MasonryGridView] and is always null.
  @override
  Widget? get separator => null;

  /// The extra widgets around [MasonryGridView], notice that the [listTopWidgets] and [listBottomWidgets] will be ignored.
  @override
  final UpdatableDataViewExtraWidgets? extra;

  /// The crossAxisCount for [MasonryGridView].
  final int crossAxisCount;

  /// The mainAxisSpacing for [MasonryGridView].
  final double? mainAxisSpacing;

  /// The crossAxisSpacing for [MasonryGridView]
  final double? crossAxisSpacing;

  @override
  _PaginationMasonryGridView<T> createState() => _PaginationMasonryGridView<T>();
}

class _PaginationMasonryGridView<T> extends State<PaginationMasonryGridView<T>> with AutomaticKeepAliveClientMixin<PaginationMasonryGridView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  var _downScrollable = false;
  dynamic _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
    _nextIndicator = widget.paginationSetting.initialIndicator;
  }

  @override
  void dispose() {
    widget.controller?.detachAppend();
    widget.controller?.detachRefresh();
    super.dispose();
  }

  bool _onScroll(ScrollNotification s) {
    _downScrollable = !s.metrics.isShortScrollArea() && s.metrics.isInBottom();
    return false;
  }

  Future<void> _getData({required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
      paginationSetting: widget.paginationSetting,
      scrollController: widget.scrollController,
      doSetState: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var view = MasonryGridView.count(
      controller: widget.scrollController,
      padding: widget.setting.padding,
      physics: widget.setting.physics ?? const AlwaysScrollableScrollPhysics(),
      reverse: widget.setting.reverse ?? false,
      shrinkWrap: widget.setting.shrinkWrap ?? false,
      // ===================================
      crossAxisCount: widget.crossAxisCount,
      mainAxisSpacing: widget.mainAxisSpacing ?? 0,
      crossAxisSpacing: widget.crossAxisSpacing ?? 0,
      itemCount: widget.data.length,
      itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]), // ignore extra innerXXX and outerXXX
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      notificationPredicate: widget.setting.appendNotificationPredicate ?? defaultScrollNotificationPredicate,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
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
                onChanged: widget.setting.onStateChanged,
                setting: widget.setting.placeholderSetting ?? const PlaceholderSetting(),
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidgets != null) ...(widget.extra?.innerTopWidgets)!,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar ?? true
                            ? ScrollbarWithMore(
                                interactive: widget.setting.scrollbarInteractive ?? false,
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

// TODO PaginationSliverMasonryGridView

/// The getData inner implementation, used in [PaginationListView._getData], [PaginationListView._getData] and [PaginationMasonryGridView._getData].
Future<void> _getDataCore<T>({
  required bool reset,
  required dynamic nextIndicator,
  required void Function(dynamic) setNextIndicator,
  required bool Function() getDownScrollable,
  // ===================================
  required void Function(bool) setLoading,
  required void Function(String) setErrorMessage,
  // ===================================
  required List<T> data,
  required Future<PagedList<T>> Function({required dynamic indicator}) getData,
  required UpdatableDataViewSetting<T> setting,
  required PaginationSetting paginationSetting,
  required ScrollController? scrollController,
  // ===================================
  required void Function() doSetState,
}) async {
  // reset page
  if (reset) {
    nextIndicator = paginationSetting.initialIndicator;
    setNextIndicator(nextIndicator);
  }

  // start loading
  setLoading(true);
  setErrorMessage('');
  if (reset) {
    if (setting.clearWhenRefresh ?? false) {
      data.clear();
    }
    setting.onStartRefreshing?.call(); // start refreshing callback
  }
  setting.onStartLoading?.call(); // start loading callback
  doSetState();

  // nothing
  if (!reset && nextIndicator == paginationSetting.nothingIndicator) {
    return Future.delayed(_kNothingRefreshDuration).then((_) {
      setErrorMessage('');
      setting.onAppend?.call([]);
      setLoading(false);
      setting.onStopLoading?.call(); // stop loading callback
      if (reset) {
        setting.onStopRefreshing?.call(); // stop refreshing callback
      }
      doSetState();
    });
  }

  // get data
  final func = getData(indicator: nextIndicator); // Future<PagedList<T>>

  // return future
  return func.then((PagedList<T> list) async {
    // success to get data without error
    setErrorMessage('');
    if (list.list.isEmpty && (setting.updateOnlyIfNotEmpty ?? false)) {
      setting.onAppend?.call([]);
      return; // got an empty list
    }
    // replace or append
    if (reset) {
      if (list.list.isNotEmpty) {
        data.clear();
        doSetState();
        await Future.delayed(_kFlashListDuration);
      }
      data.addAll(list.list);
    } else {
      data.addAll(list.list);
      if (getDownScrollable()) {
        scrollController?.scrollDown();
      }
    }
    setNextIndicator(list.next);
    setting.onAppend?.call(list.list);
  }).catchError((e) {
    // error aroused
    setErrorMessage(e.toString());
    if (setting.clearWhenError ?? false) {
      data.clear();
    }
    setting.onError?.call(e);
  }).whenComplete(() {
    // finish loading and setState
    setLoading(false);
    setting.onStopLoading?.call(); // stop loading callback
    if (reset) {
      setting.onStopRefreshing?.call(); // stop refreshing callback
    }
    doSetState();
  });
}
