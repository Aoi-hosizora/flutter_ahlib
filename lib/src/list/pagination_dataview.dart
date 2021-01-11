import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// A duration for flashing list after clear the data.
final _kFlashListDuration = Duration(milliseconds: 50);

/// A duration for fake refreshing for nothing.
final _kNothingRefreshDuration = Duration(milliseconds: 200);

/// An abstract [UpdatableDataView] for pagination data view, including
/// [PaginationListView], [PaginationSliverListView], [PaginationStaggeredGridView].
abstract class PaginationDataView<T> extends UpdatableDataView<T> {
  const PaginationDataView({Key key}) : super(key: key);

  /// The function to get list data with pagination.
  Future<PagedList<T>> Function({dynamic indicator}) get getData;

  /// The pagination setting.
  PaginationSetting get paginationSetting;
}

/// Pagination [ListView] is an implementation of [PaginationDataView], with
/// [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar] and [ListView].
class PaginationListView<T> extends PaginationDataView<T> {
  const PaginationListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    this.separator,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController controller;

  /// The controller for [ListView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [ListView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator in [ListView].
  final Widget separator;

  /// The extra widgets.
  final UpdatableDataViewExtraWidgets extra;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _downScrollable = false;
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  dynamic _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
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

  Future<void> _getData({@required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
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
  bool get wantKeepAlive => widget.setting.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var view = ListView.separated(
      controller: widget.scrollController,
      padding: widget.setting.padding,
      physics: widget.setting.physics,
      reverse: widget.setting.reverse,
      shrinkWrap: widget.setting.shrinkWrap,
      // ===================================
      separatorBuilder: (c, idx) => widget.separator ?? SizedBox(height: 0),
      itemCount: widget.data.length,
      itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
        child: Column(
          crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (widget.extra?.outerTopWidget != null) widget.extra.outerTopWidget,
            Expanded(
              child: PlaceholderText.from(
                onRefresh: () => _refreshIndicatorKey.currentState?.show(),
                forceState: _forceState,
                isLoading: _loading,
                isEmpty: widget.data.isEmpty,
                errorText: _errorMessage,
                onChanged: widget.setting.onStateChanged,
                setting: widget.setting.placeholderSetting,
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidget != null) widget.extra.innerTopWidget,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar
                            ? Scrollbar(
                                thickness: widget.setting.scrollbarThickness,
                                radius: widget.setting.scrollbarRadius,
                                child: view,
                              )
                            : view,
                      ),
                    ),
                    if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                  ],
                ),
              ),
            ),
            if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
          ],
        ),
      ),
    );
  }
}

/// Pagination [SliverList] is an implementation of [PaginationDataView], with
/// [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar], [CustomScrollView] and [SliverList].
class PaginationSliverListView<T> extends PaginationDataView<T> {
  const PaginationSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    this.hasOverlapAbsorber = false,
    this.separator,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController controller;

  /// The controller for [CustomScrollView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [SliverList].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber]. And if the value is true, you may need to
  /// wrap this widget with [Builder] to get correct [ScrollController] by [NestedScrollView.sliverOverlapAbsorberHandleFor].
  final bool hasOverlapAbsorber;

  /// The separator in [SliverList].
  final Widget separator;

  /// The extra widgets.
  final UpdatableDataViewExtraWidgets extra;

  @override
  _PaginationSliverListViewState<T> createState() => _PaginationSliverListViewState<T>();
}

class _PaginationSliverListViewState<T> extends State<PaginationSliverListView<T>> with AutomaticKeepAliveClientMixin<PaginationSliverListView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _downScrollable = false;
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  dynamic _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
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

  Future<void> _getData({@required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
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
  bool get wantKeepAlive => widget.setting.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var view = CustomScrollView(
      controller: widget.scrollController,
      physics: widget.setting.physics,
      reverse: widget.setting.reverse,
      shrinkWrap: widget.setting.shrinkWrap,
      // ===================================
      slivers: [
        if (widget.hasOverlapAbsorber)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        SliverPadding(
          padding: widget.setting.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: widget.separator == null
                ? SliverChildBuilderDelegate(
                    (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                    childCount: widget.data.length,
                  )
                : SliverSeparatedBuilderDelegate(
                    (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                    childCount: widget.data.length,
                    separator: widget.separator,
                  ),
          ),
        ),
      ],
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
        child: Column(
          crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (widget.extra?.outerTopWidget != null) widget.extra.outerTopWidget,
            Expanded(
              child: PlaceholderText.from(
                onRefresh: () => _refreshIndicatorKey.currentState?.show(),
                forceState: _forceState,
                isLoading: _loading,
                isEmpty: widget.data.isEmpty,
                errorText: _errorMessage,
                onChanged: widget.setting.onStateChanged,
                setting: widget.setting.placeholderSetting,
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidget != null) widget.extra.innerTopWidget,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar
                            ? Scrollbar(
                                thickness: widget.setting.scrollbarThickness,
                                radius: widget.setting.scrollbarRadius,
                                child: view,
                              )
                            : view,
                      ),
                    ),
                    if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                  ],
                ),
              ),
            ),
            if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
          ],
        ),
      ),
    );
  }
}

/// Pagination [StaggeredGridView] is an implementation of [PaginationDataView], with
/// [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar] and [StaggeredGridView].
class PaginationStaggeredGridView<T> extends PaginationDataView<T> {
  const PaginationStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    @required this.staggeredTileBuilder,
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null && crossAxisCount != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data with pagination.
  @override
  final Future<PagedList<T>> Function({dynamic indicator}) getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// The pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller for the behavior.
  @override
  final UpdatableDataViewController controller;

  /// The controller for [StaggeredGridView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [StaggeredGridView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The staggeredTileBuilder for [StaggeredGridView].
  final StaggeredTile Function(int) staggeredTileBuilder;

  /// The crossAxisCount for [StaggeredGridView].
  final int crossAxisCount;

  /// The mainAxisSpacing for [StaggeredGridView].
  final double mainAxisSpacing;

  /// The crossAxisSpacing for [StaggeredGridView]
  final double crossAxisSpacing;

  /// The extra widgets.
  final UpdatableDataViewExtraWidgets extra;

  @override
  _PaginationStaggeredGridViewState<T> createState() => _PaginationStaggeredGridViewState<T>();
}

class _PaginationStaggeredGridViewState<T> extends State<PaginationStaggeredGridView<T>> with AutomaticKeepAliveClientMixin<PaginationStaggeredGridView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _downScrollable = false;
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';
  dynamic _nextIndicator;

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
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

  Future<void> _getData({@required bool reset}) async {
    _forceState = null;
    return _getDataCore(
      reset: reset,
      nextIndicator: _nextIndicator,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setNextIndicator: (i) => _nextIndicator = i,
      getDownScrollable: () => _downScrollable,
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
  bool get wantKeepAlive => widget.setting.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var view = StaggeredGridView.countBuilder(
      controller: widget.scrollController,
      padding: widget.setting.padding,
      physics: widget.setting.physics,
      reverse: widget.setting.reverse,
      shrinkWrap: widget.setting.shrinkWrap,
      // ===================================
      staggeredTileBuilder: widget.staggeredTileBuilder,
      crossAxisCount: widget.crossAxisCount,
      mainAxisSpacing: widget.mainAxisSpacing ?? 0,
      crossAxisSpacing: widget.crossAxisSpacing ?? 0,
      itemCount: widget.data.length,
      itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
        child: Column(
          crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (widget.extra?.outerTopWidget != null) widget.extra.outerTopWidget,
            Expanded(
              child: PlaceholderText.from(
                onRefresh: () => _refreshIndicatorKey.currentState?.show(),
                forceState: _forceState,
                isLoading: _loading,
                isEmpty: widget.data.isEmpty,
                errorText: _errorMessage,
                onChanged: widget.setting.onStateChanged,
                setting: widget.setting.placeholderSetting,
                childBuilder: (c) => Column(
                  crossAxisAlignment: widget.extra?.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    if (widget.extra?.innerTopWidget != null) widget.extra.innerTopWidget,
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar
                            ? Scrollbar(
                                thickness: widget.setting.scrollbarThickness,
                                radius: widget.setting.scrollbarRadius,
                                child: view,
                              )
                            : view,
                      ),
                    ),
                    if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                  ],
                ),
              ),
            ),
            if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
          ],
        ),
      ),
    );
  }
}

/// A list of pagination settings for [PaginationDataView].
class PaginationSetting {
  const PaginationSetting({
    this.initialIndicator = 1,
    this.nothingIndicator,
  }) : assert(initialIndicator != null);

  /// The initial indicator for pagination, default is 1 and not null. Notice that if you are
  /// using seek based pagination strategy, it is necessary to set this value to your own.
  final int initialIndicator;

  /// The indicator which means there is no data at this page, default value is null for no check.
  final dynamic nothingIndicator;
}

/// A data model for [PaginationDataView], represents the returned data.
class PagedList<T> {
  const PagedList({@required this.list, @required this.next});

  /// The list data.
  final List<T> list;

  /// The next indicator for pagination.
  final dynamic next;
}

/// The getData inner implementation, need [setLoading], [setErrorMessage], [nextIndicator] set-get and [getDownScrollable].
Future<void> _getDataCore<T>({
  @required bool reset,
  @required dynamic nextIndicator,
  // ===================================
  @required void Function(bool) setLoading,
  @required void Function(String) setErrorMessage,
  @required void Function(dynamic) setNextIndicator,
  @required bool Function() getDownScrollable,
  // ===================================
  @required List<T> data,
  @required Future<PagedList<T>> Function({dynamic indicator}) getData,
  @required UpdatableDataViewSetting<T> setting,
  @required PaginationSetting paginationSetting,
  @required ScrollController scrollController,
  // ===================================
  @required void Function() doSetState,
}) async {
  assert(reset != null);
  assert(nextIndicator != null);
  assert(setLoading != null);
  assert(setErrorMessage != null);
  assert(setNextIndicator != null);
  assert(getDownScrollable != null);
  assert(data != null);
  assert(getData != null);
  assert(setting != null);
  assert(paginationSetting != null);
  assert(scrollController != null);
  assert(doSetState != null);

  // reset page
  if (reset) {
    setNextIndicator(paginationSetting.initialIndicator);
  }

  // start loading
  setLoading(true);
  setErrorMessage('');
  if (reset) {
    if (setting.clearWhenRefresh) {
      data.clear();
    }
    setting.onStartRefreshing?.call();
  }
  setting.onStartLoading?.call();
  doSetState();

  // nothing
  if (nextIndicator == paginationSetting.nothingIndicator) {
    return Future.delayed(_kNothingRefreshDuration).then((_) {
      setErrorMessage('');
      setting.onAppend?.call([]);
      setting.onStopLoading?.call();
      doSetState();
    });
  }

  // get data
  final func = getData(indicator: nextIndicator); // Future<PagedList<T>>

  // return future
  return func.then((PagedList<T> list) async {
    // success to get data without error
    setErrorMessage('');
    if (list.list.isEmpty && setting.updateOnlyIfNotEmpty) {
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
    if (setting.clearWhenError) {
      data.clear();
    }
    setting.onError?.call(e);
  }).whenComplete(() {
    // finish loading and setState
    setLoading(false);
    setting.onStopLoading?.call();
    if (reset) {
      setting.onStopRefreshing?.call();
    }
    doSetState();
  });
}
