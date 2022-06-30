import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// The duration for flashing list after clear the data.
final _kFlashListDuration = Duration(milliseconds: 50);

/// An abstract [UpdatableDataView] for refreshable data view, implements by [RefreshableListView], [RefreshableSliverListView], [RefreshableMasonryGridView].
abstract class RefreshableDataView<T> extends UpdatableDataView<T> {
  const RefreshableDataView({Key? key}) : super(key: key);

  /// The function to get list data.
  Future<List<T>> Function() get getData;
}

/// A [RefreshableDataView] with [ListView], includes [RefreshIndicator], [PlaceholderText], [Scrollbar] and [ListView].
class RefreshableListView<T> extends RefreshableDataView<T> {
  const RefreshableListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    // ===================================
    this.separator,
    this.extra,
  }) : super(key: key);

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
  final UpdatableDataViewController? controller;

  /// The controller for [ListView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [ListView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator in [ListView].
  final Widget? separator;

  /// The extra widgets.
  final UpdatableDataViewExtraWidgets? extra;

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
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
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var top = widget.extra?.inListTopWidgets ?? [];
    var data = widget.data;
    var bottom = widget.extra?.inListBottomWidgets ?? [];
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
          return SizedBox(height: 0);
        } else if (idx < tl + dl - 1) {
          return widget.separator ?? SizedBox(height: 0);
        } else {
          return SizedBox(height: 0);
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: Column(
        crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (widget.extra?.outerTopWidget != null) (widget.extra?.outerTopWidget)!,
          if (widget.extra?.outerTopDivider != null) (widget.extra?.outerTopDivider)!,
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
                  if (widget.extra?.innerTopWidget != null) (widget.extra?.innerTopWidget)!,
                  if (widget.extra?.innerTopDivider != null) (widget.extra?.innerTopDivider)!,
                  Expanded(
                    child: widget.setting.showScrollbar ?? true
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomDivider != null) (widget.extra?.innerBottomDivider)!,
                  if (widget.extra?.innerBottomWidget != null) (widget.extra?.innerBottomWidget)!,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomDivider != null) (widget.extra?.outerBottomDivider)!,
          if (widget.extra?.outerBottomWidget != null) (widget.extra?.outerBottomWidget)!,
        ],
      ),
    );
  }
}

/// A [RefreshableDataView] with [SliverList], includes [RefreshIndicator], [PlaceholderText], [Scrollbar], [CustomScrollView] and [SliverList].
class RefreshableSliverListView<T> extends RefreshableDataView<T> {
  const RefreshableSliverListView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    // ===================================
    this.separator,
    this.useOverlapInjector = false,
    this.extra,
  }) : super(key: key);

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
  final UpdatableDataViewController? controller;

  /// The controller for [CustomScrollView], you have to wrap this widget with [Builder] and use [PrimaryScrollController.of] to get correct
  /// [ScrollController] from [NestedScrollView], JUST NOT TO use [NestedScrollView]'s scrollController directly.
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [SliverList].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator in [SliverList].
  final Widget? separator;

  /// The switcher to use [SliverOverlapInjector], defaults to false. This is useful when outer [NestedScrollView] use [SliverOverlapAbsorber],
  /// or you can manually set the padding in [UpdatableDataViewExtraWidgets] and just set this value to false. If set to true, you have to wrap
  /// this widget with [Builder] to get correct [SliverOverlapAbsorber] handler by [NestedScrollView.sliverOverlapAbsorberHandleFor].
  final bool? useOverlapInjector;

  /// The extra widgets.
  final UpdatableDataViewExtraWidgets? extra;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
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
  bool get wantKeepAlive => widget.setting.wantKeepAlive ?? true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var top = widget.extra?.inListTopWidgets ?? [];
    var data = widget.data;
    var bottom = widget.extra?.inListBottomWidgets ?? [];
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
                  return SizedBox(height: 0);
                } else if (idx < tl + dl - 1) {
                  return widget.separator ?? SizedBox(height: 0);
                } else {
                  return SizedBox(height: 0);
                }
              },
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
          if (widget.extra?.outerTopWidget != null) (widget.extra?.outerTopWidget)!,
          if (widget.extra?.outerTopDivider != null) (widget.extra?.outerTopDivider)!,
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
                  if (widget.extra?.innerTopWidget != null) (widget.extra?.innerTopWidget)!,
                  if (widget.extra?.innerTopDivider != null) (widget.extra?.innerTopDivider)!,
                  Expanded(
                    child: widget.setting.showScrollbar ?? true
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomDivider != null) (widget.extra?.innerBottomDivider)!,
                  if (widget.extra?.innerBottomWidget != null) (widget.extra?.innerBottomWidget)!,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomDivider != null) (widget.extra?.outerBottomDivider)!,
          if (widget.extra?.outerBottomWidget != null) (widget.extra?.outerBottomWidget)!,
        ],
      ),
    );
  }
}

/// A [RefreshableDataView] with [MasonryGridView], includes [RefreshIndicator], [PlaceholderText], [Scrollbar] and [MasonryGridView].
class RefreshableMasonryGridView<T> extends RefreshableDataView<T> {
  const RefreshableMasonryGridView({
    Key? key,
    required this.data,
    required this.getData,
    this.setting = const UpdatableDataViewSetting(),
    this.controller,
    this.scrollController,
    required this.itemBuilder,
    // ===================================
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.extra,
  }) : super(key: key);

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
  final UpdatableDataViewController? controller;

  /// The controller for [MasonryGridView].
  @override
  final ScrollController? scrollController;

  /// The itemBuilder for [MasonryGridView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The crossAxisCount for [MasonryGridView].
  final int crossAxisCount;

  /// The mainAxisSpacing for [MasonryGridView], defaults to 0.
  final double? mainAxisSpacing;

  /// The crossAxisSpacing for [MasonryGridView], defaults to 0.
  final double? crossAxisSpacing;

  /// The extra widgets, notice that the inListXXX and outListXXX will be ignored.
  final UpdatableDataViewExtraWidgets? extra;

  @override
  _RefreshableMasonryGridView<T> createState() => _RefreshableMasonryGridView<T>();
}

class _RefreshableMasonryGridView<T> extends State<RefreshableMasonryGridView<T>> with AutomaticKeepAliveClientMixin<RefreshableMasonryGridView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState? _forceState = PlaceholderState.nothing;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst ?? true) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
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
      itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]), // ignore extra inListXXX and outListXXX
    );

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: Column(
        crossAxisAlignment: widget.extra?.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (widget.extra?.outerTopWidget != null) (widget.extra?.outerTopWidget)!,
          if (widget.extra?.outerTopDivider != null) (widget.extra?.outerTopDivider)!,
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
                  if (widget.extra?.innerTopWidget != null) (widget.extra?.innerTopWidget)!,
                  if (widget.extra?.innerTopDivider != null) (widget.extra?.innerTopDivider)!,
                  Expanded(
                    child: widget.setting.showScrollbar ?? true
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
                  ),
                  if (widget.extra?.innerBottomDivider != null) (widget.extra?.innerBottomDivider)!,
                  if (widget.extra?.innerBottomWidget != null) (widget.extra?.innerBottomWidget)!,
                ],
              ),
            ),
          ),
          if (widget.extra?.outerBottomDivider != null) (widget.extra?.outerBottomDivider)!,
          if (widget.extra?.outerBottomWidget != null) (widget.extra?.outerBottomWidget)!,
        ],
      ),
    );
  }
}

/// The getData inner implementation, used in [RefreshableListView._getData], [RefreshableListView._getData] and [RefreshableMasonryGridView._getData].
Future<void> _getDataCore<T>({
  required void Function(bool) setLoading,
  required void Function(String) setErrorMessage,
  // ===================================
  required List<T> data,
  required Future<List<T>> Function() getData,
  required UpdatableDataViewSetting<T> setting,
  // ===================================
  required void Function() doSetState,
}) async {
  // start loading
  setLoading(true);
  setErrorMessage('');
  if (setting.clearWhenRefresh ?? false) {
    data.clear();
  }
  setting.onStartRefreshing?.call(); // start refreshing
  setting.onStartLoading?.call(); // start loading
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
    if (setting.clearWhenError ?? false) {
      data.clear();
    }
    setting.onError?.call(e);
  }).whenComplete(() {
    // finish loading and setState
    setLoading(false);
    setting.onStopLoading?.call(); // stop loading
    setting.onStopRefreshing?.call(); // stop refreshing
    doSetState();
  });
}
