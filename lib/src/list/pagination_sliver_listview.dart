import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// Appendable pagination `SliverListView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class PaginationSliverListView<T> extends StatefulWidget {
  const PaginationSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
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
        assert(itemBuilder != null),
        super(key: key);

  final List<T> data;
  final GetPageDataFunction<T> getData;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholderSetting;
  final ScrollMoreController controller;
  final ScrollController innerController;
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
  _PaginationSliverListViewState<T> createState() => _PaginationSliverListViewState<T>();
}

class _PaginationSliverListViewState<T> extends State<PaginationSliverListView<T>>
    with AutomaticKeepAliveClientMixin<PaginationSliverListView<T>> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  // page data, error message
  int _page = 0;
  bool _loading = true;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());

    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  Future<void> _getData({@required bool reset}) async {
    if (reset) {
      _page = 0;
    }
    // 0 -> 1
    _page++;

    // start refresh
    final func = widget.getData(page: _page);
    _loading = true;
    if (mounted) setState(() {});

    return func.then((List<T> list) async {
      // success to get data, empty errorMessage
      _errorMessage = null;
      if (reset) {
        widget.data.clear();
        if (mounted) setState(() {});
        await Future.delayed(Duration(milliseconds: 20)); // must delayed
        widget.data.addAll(list);
      } else {
        widget.data.addAll(list); // append directly
        widget.controller?.scrollDown();
      }
      if (list.length == 0) {
        _page--; // not next, restore last page
      }
    }).catchError((e) {
      // error arowsed, restore last page
      _errorMessage = e.toString();
      _page--;
    }).whenComplete(() {
      // finish loading
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
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
      ),
    );
  }
}
