import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// Refreshable `SliverListView` which packing `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class RefreshableSliverListView<T> extends StatefulWidget {
  const RefreshableSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
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
        assert(itemBuilder != null),
        super(key: key);

  final List<T> data;
  final GetNonPageDataFunction<T> getData;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholderSetting;
  final ScrollMoreController controller;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool reverse;
  final bool primary;
  final Widget separator;
  final Widget topSliver;
  final Widget bottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>>
    with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
  @override
  bool get wantKeepAlive => true;

  // copy of widget.controller or new controller
  ScrollMoreController _controller;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  // loading, error message
  bool _loading = true;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());

    _controller = widget.controller ?? ScrollMoreController();
    _controller.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    if (_controller != widget.controller) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _getData() async {
    // start refresh
    final func = widget.getData();
    _loading = true;
    if (mounted) setState(() {});

    return func.then((List<T> list) async {
      // success to get data,  empty errorMessage
      _errorMessage = null;
      widget.data.clear();
      if (mounted) setState(() {});

      await Future.delayed(Duration(milliseconds: 20)); // must delayed
      widget.data.addAll(list);
    }).catchError((e) {
      // error arowsed
      _errorMessage = e.toString();
    }).whenComplete(() {
      // finish loading
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
            controller: _controller,
            shrinkWrap: widget.shrinkWrap ?? false,
            physics: widget.physics,
            reverse: widget.reverse ?? false,
            slivers: [
              widget.topSliver ?? SliverToBoxAdapter(),
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
              widget.bottomSliver ?? SliverToBoxAdapter(),
            ],
          ),
        ),
      ),
    );
  }
}
