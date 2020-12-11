import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_list_controller.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_separator_builder_delegate.dart';

/// Refreshable [SliverList] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableSliverListView<T> extends StatefulWidget {
  const RefreshableSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableListSetting(),
    this.controller,
    //
    this.scrollController,
    this.outScrollController,
    @required this.itemBuilder,
    this.padding,
    this.physics,
    this.reverse,
    this.shrinkWrap,
    this.hasOverlapAbsorber = false,
    this.separator,
    //
    this.topSliver,
    this.bottomSliver,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
        super(key: key);

  /// List data, need to create this outside.
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Setting of updatable list.
  final UpdatableListSetting setting;

  /// Updatable list controller, with [UpdatableListController].
  final UpdatableListController controller;

  //

  /// The controller for inner [CustomScrollView].
  final ScrollController scrollController;

  /// The controller for outer [NestedScrollView].
  final ScrollController outScrollController;

  /// The itemBuilder for [SliverList].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [SliverList].
  final EdgeInsetsGeometry padding;

  /// The physics for [CustomScrollView].
  final ScrollPhysics physics;

  /// The reverse for [CustomScrollView].
  final bool reverse;

  /// The shrinkWrap for [CustomScrollView].
  final bool shrinkWrap;

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber].
  final bool hasOverlapAbsorber;

  /// The separator between items in [ListView].
  final Widget separator;

  //

  /// The widget before [SliverList].
  final Widget topSliver;

  /// The widget after [SliverList].
  final Widget bottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  PlaceholderState _forceState;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  Future<void> _getData() async {
    // start loading
    _loading = true;
    _forceState = null;
    if (widget.setting.clearWhenRefresh) {
      _errorMessage = '';
      widget.data.clear();
    }
    widget.setting.onStartLoading?.call();
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      if (widget.setting.updateOnlyIfNotEmpty && list.isEmpty) {
        return; // get an empty list
      }
      if (widget.data.isNotEmpty) {
        widget.data.clear();
        if (mounted) setState(() {});
        await Future.delayed(Duration(milliseconds: 20));
      }
      widget.data.addAll(list);
      widget.setting.onAppend?.call(list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
      if (widget.setting.clearWhenError) {
        widget.data.clear();
      }
      widget.setting.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      widget.setting.onStopLoading?.call();
      if (mounted) setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: PlaceholderText.from(
        onRefresh: _refreshIndicatorKey.currentState?.show,
        forceState: _forceState,
        isLoading: _loading,
        isEmpty: widget.data.isEmpty,
        errorText: _errorMessage,
        onChanged: widget.setting.onStateChanged,
        setting: widget.setting.placeholderSetting,
        childBuilder: (c) => Scrollbar(
          child: CustomScrollView(
            // ===================================
            controller: widget.scrollController,
            // ===================================
            physics: widget.physics,
            reverse: widget.reverse ?? false,
            shrinkWrap: widget.shrinkWrap ?? false,
            // ===================================
            slivers: [
              if (widget.hasOverlapAbsorber)
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
              if (widget.topSliver != null) widget.topSliver,
              SliverPadding(
                padding: widget.padding ?? EdgeInsets.zero,
                sliver: SliverList(
                  delegate: widget.separator == null
                      ? SliverChildBuilderDelegate(
                          (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                          childCount: widget.data.length,
                        )
                      : SliverSeparatorBuilderDelegate(
                          (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                          childCount: widget.data.length,
                          separator: widget.separator,
                        ),
                ),
              ),
              if (widget.bottomSliver != null) widget.bottomSliver,
            ],
            // ===================================
          ),
        ),
      ),
    );
  }
}
