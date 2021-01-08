import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// A duration for flashing list after clear the data.
final _kFlashListDuration = Duration(milliseconds: 50);

/// An abstract [UpdatableDataView] for refreshable data view, including
/// [RefreshableListView], [RefreshableSliverListView], [RefreshableStaggeredGridView].
abstract class RefreshableDataView<T> extends UpdatableDataView<T> {
  const RefreshableDataView({Key key}) : super(key: key);

  /// The function to get list data.
  Future<List<T>> Function() get getData;
}

/// Refreshable [ListView] is an implementation of [RefreshableDataView], with
/// [RefreshIndicator], [PlaceholderText], [Scrollbar] and [ListView].
class RefreshableListView<T> extends RefreshableDataView<T> {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    this.separator,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data.
  @override
  final Future<List<T>> Function() getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

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
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    widget.controller?.detachRefresh();
    super.dispose();
  }

  Future<void> _getData() async {
    _forceState = null;
    return _getDataCore(
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
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
                    child: widget.setting.showScrollbar
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
        ],
      ),
    );
  }
}

/// Refreshable [SliverList] is an implementation of [RefreshableDataView], with
/// [RefreshIndicator], [PlaceholderText], [Scrollbar], [CustomScrollView] and [SliverList].
class RefreshableSliverListView<T> extends RefreshableDataView<T> {
  const RefreshableSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    this.hasOverlapAbsorber = false,
    this.separator,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data.
  @override
  final Future<List<T>> Function() getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

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
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    widget.controller?.detachRefresh();
    super.dispose();
  }

  Future<void> _getData() async {
    _forceState = null;
    return _getDataCore(
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
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
                    child: widget.setting.showScrollbar
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
        ],
      ),
    );
  }
}

/// Refreshable [StaggeredGridView] is an implementation of [RefreshableDataView], with
/// [RefreshIndicator], [PlaceholderText], [Scrollbar] and [StaggeredGridView].
class RefreshableStaggeredGridView<T> extends RefreshableDataView<T> {
  const RefreshableStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    // ===================================
    @required this.staggeredTileBuilder,
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.extra,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null && crossAxisCount != null),
        super(key: key);

  /// The list of data.
  @override
  final List<T> data;

  /// The function to get list data.
  @override
  final Future<List<T>> Function() getData;

  /// The display and behavior setting.
  @override
  final UpdatableDataViewSetting<T> setting;

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
  _RefreshableStaggeredGridViewState<T> createState() => _RefreshableStaggeredGridViewState<T>();
}

class _RefreshableStaggeredGridViewState<T> extends State<RefreshableStaggeredGridView<T>> with AutomaticKeepAliveClientMixin<RefreshableStaggeredGridView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    } else {
      _forceState = widget.data.isEmpty ? PlaceholderState.nothing : PlaceholderState.normal;
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    widget.controller?.detachRefresh();
    super.dispose();
  }

  Future<void> _getData() async {
    _forceState = null;
    return _getDataCore(
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      data: widget.data,
      getData: widget.getData,
      setting: widget.setting,
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
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
                    child: widget.setting.showScrollbar
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomWidget != null) widget.extra.innerBottomWidget,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomWidget != null) widget.extra.outerBottomWidget,
        ],
      ),
    );
  }
}

/// The getData inner implementation, used in [RefreshableListView._getData],
/// [RefreshableListView._getData] and [RefreshableStaggeredGridView._getData].
Future<void> _getDataCore<T>({
  @required void Function(bool) setLoading,
  @required void Function(String) setErrorMessage,
  // ===================================
  @required List<T> data,
  @required Future<List<T>> Function() getData,
  @required UpdatableDataViewSetting<T> setting,
  // ===================================
  @required void Function() doSetState,
}) async {
  assert(setLoading != null);
  assert(setErrorMessage != null);
  assert(data != null);
  assert(getData != null);
  assert(setting != null);
  assert(doSetState != null);

  // start loading
  setLoading(true);
  setErrorMessage('');
  if (setting.clearWhenRefresh) {
    data.clear();
  }
  setting.onStartRefreshing?.call();
  setting.onStartLoading?.call();
  doSetState();

  // get data
  final func = getData(); // Future<List<T>>

  // return future
  return func.then((List<T> list) async {
    // success to get data without error
    setErrorMessage('');
    if (data.isNotEmpty) {
      data.clear();
      doSetState();
      await Future.delayed(_kFlashListDuration);
    }
    data.addAll(list);
    setting.onAppend?.call(list);
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
    setting.onStopRefreshing?.call();
    doSetState();
  });
}
