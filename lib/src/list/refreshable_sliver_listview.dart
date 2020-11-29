import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [SliverList] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableSliverListView<T> extends StatefulWidget {
  const RefreshableSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onAppend,
    this.onError,
    this.clearWhenRefreshing = false,
    this.clearWhenError = false,
    this.refreshFirst = true,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    this.innerController,
    @required this.itemBuilder,
    this.separator,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    this.topSliver,
    this.bottomSliver,
  })  : assert(data != null),
        assert(getData != null),
        assert(clearWhenRefreshing != null),
        assert(clearWhenError != null),
        assert(refreshFirst != null),
        assert(itemBuilder != null),
        super(key: key);

  /// List data, need to create this outside.
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Callback when data has been appended.
  final void Function(List<T>) onAppend;

  /// Callback when error invoked.
  final void Function(dynamic) onError;

  /// Clear list when refreshing data.
  final bool clearWhenRefreshing;

  /// Clear list when error aroused.
  final bool clearWhenError;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// The controller for [RefreshableSliverListView], with [ScrollMoreController].
  final ScrollMoreController controller;

  /// The controller for [CustomScrollView].
  final ScrollController innerController;

  /// The itemBuilder for [SliverChildBuilderDelegate] in [SliverList].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator between items in [ListView].
  final Widget separator;

  /// The padding for [SliverList].
  final EdgeInsetsGeometry padding;

  /// The shrinkWrap for [CustomScrollView].
  final bool shrinkWrap;

  /// The physics for [CustomScrollView].
  final ScrollPhysics physics;

  /// The reverse for [CustomScrollView].
  final bool reverse;

  /// The primary for [CustomScrollView].
  final bool primary;

  /// The widget before [SliverList].
  final Widget topSliver;

  /// The widget after [SliverList].
  final Widget bottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.refreshFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  Future<void> _getData() async {
    // start loading
    _loading = true;
    if (widget.clearWhenRefreshing) {
      _errorMessage = '';
      widget.data.clear();
    }
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      widget.data.clear();
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 20));
      widget.data.addAll(list);
      widget.onAppend?.call(list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
      if (widget.clearWhenError) {
        widget.data.clear();
      }
      widget.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PlaceholderText.from(
      onRefresh: _refreshIndicatorKey.currentState?.show,
      isLoading: _loading,
      isEmpty: widget.data.isEmpty,
      errorText: _errorMessage,
      onChanged: widget.onStateChanged,
      setting: widget.placeholderSetting,
      childBuilder: (c) => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(),
        child: Scrollbar(
          child: CustomScrollView(
            controller: widget.innerController,
            shrinkWrap: widget.shrinkWrap ?? false,
            physics: widget.physics,
            reverse: widget.reverse ?? false,
            slivers: [
              if (widget.topSliver != null) widget.topSliver,
              SliverPadding(
                padding: widget.padding,
                sliver: SliverList(
                  delegate: widget.separator == null
                      ? SliverChildBuilderDelegate(
                          (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                          childCount: widget.data.length,
                        )
                      : SliverChildBuilderDelegate(
                          (c, idx) => idx % 2 == 0
                              ? widget.itemBuilder(
                                  c,
                                  widget.data[idx ~/ 2],
                                )
                              : widget.separator,
                          childCount: widget.data.length * 2 - 1,
                        ),
                ),
              ),
              if (widget.bottomSliver != null) widget.bottomSliver,
            ],
          ),
        ),
      ),
    );
  }
}
