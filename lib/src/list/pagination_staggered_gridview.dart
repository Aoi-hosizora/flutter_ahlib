import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/list/type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Appendable pagination `StaggeredGridView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class PaginationStaggeredGridView<T> extends StatefulWidget {
  const PaginationStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    @required this.itemBuilder,
    @required this.staggeredTileBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    @required this.crossAxisCount,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.topWidget,
    this.bottomWidget,
  })  : assert(data != null),
        assert(getData != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null),
        assert(crossAxisCount != null),
        super(key: key);

  final List<T> data;
  final GetPageDataFunction<T> getData;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholderSetting;
  final ScrollMoreController controller;
  final Widget Function(BuildContext, T) itemBuilder;
  final StaggeredTile Function(int) staggeredTileBuilder;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool reverse;
  final bool primary;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _PaginationStaggeredGridViewState<T> createState() => _PaginationStaggeredGridViewState<T>();
}

class _PaginationStaggeredGridViewState<T> extends State<PaginationStaggeredGridView<T>>
    with AutomaticKeepAliveClientMixin<PaginationStaggeredGridView<T>> {
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

    widget.controller?.attachRefresh(_refreshIndicatorKey);
    widget.controller?.attachAppend(_appendIndicatorKey);
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
          childBuilder: (c) => Column(
            children: [
              widget.topWidget ?? SizedBox(height: 0),
              Expanded(
                child: Scrollbar(
                  child: StaggeredGridView.countBuilder(
                    controller: widget.controller,
                    padding: widget.padding,
                    shrinkWrap: widget.shrinkWrap ?? false,
                    physics: widget.physics,
                    reverse: widget.reverse ?? false,
                    primary: widget.primary,
                    crossAxisSpacing: widget.crossAxisSpacing,
                    mainAxisSpacing: widget.mainAxisSpacing,
                    crossAxisCount: widget.crossAxisCount,
                    staggeredTileBuilder: widget.staggeredTileBuilder,
                    itemCount: widget.data.length,
                    itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                  ),
                ),
              ),
              widget.bottomWidget ?? SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
