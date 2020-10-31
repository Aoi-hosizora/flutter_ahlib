import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [SliverList] with [RefreshIndicator], [PlaceholderText], [Scrollbar].
class RefreshableSliverListView<T> extends StatefulWidget {
  const RefreshableSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.refreshFirst = true,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    this.innerController,
    @required this.itemBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    this.separator,
    this.topSliver,
    this.bottomSliver,
  })  : assert(data != null),
        assert(getData != null),
        assert(refreshFirst != null),
        assert(itemBuilder != null),
        assert(controller == null || innerController != null),
        super(key: key);

  /// List data, need to create this list outside [RefreshableSliverListView].
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// The controller for [RefreshableSliverListView], with more helper functions.
  final ScrollMoreController controller;

  /// The controller for [CustomScrollView], which is called a inner controller.
  final ScrollController innerController;

  /// The itemBuilder for [SliverChildBuilderDelegate] in [SliverList].
  final Widget Function(BuildContext, T) itemBuilder;

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

  /// The separator between items in [SliverList].
  final Widget separator;

  /// The widget before [SliverList].
  final Widget topSliver;

  /// The widget after [SliverList].
  final Widget bottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.refreshFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  bool _loading = true;
  String _errorMessage;

  Future<void> _getData() async {
    // start loading
    final func = widget.getData();
    _loading = true;
    if (mounted) setState(() {});

    // return future
    return func.then((List<T> list) async {
      // success to get data with no error
      _errorMessage = null;
      widget.data.clear();
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 20)); // must delayed

      // set to the new list
      widget.data.addAll(list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: PlaceholderText.from(
        setting: widget.placeholderSetting,
        onRefresh: _refreshIndicatorKey.currentState?.show,
        isLoading: _loading,
        errorText: _errorMessage,
        isEmpty: widget.data.isEmpty,
        onChanged: widget.onStateChanged,
        childBuilder: (c) => Scrollbar(
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
