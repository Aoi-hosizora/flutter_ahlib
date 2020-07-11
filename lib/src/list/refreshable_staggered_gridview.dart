import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/list/type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Refreshable `StaggeredGridView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
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
  final GetNonPageDataFunction<T> getData;
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
  _RefreshableStaggeredGridViewState<T> createState() => _RefreshableStaggeredGridViewState<T>();
}

class _RefreshableStaggeredGridViewState<T> extends State<RefreshableStaggeredGridView<T>>
    with AutomaticKeepAliveClientMixin<RefreshableStaggeredGridView<T>> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  // loading, error message
  bool _loading = false;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
  }

  Future<void> _getData() async {
    // start refresh
    final func = widget.getData();
    _loading = true;
    if (mounted) setState(() {});

    return func.then((List<T> list) async {
      // success to get data, update maxId, empty errorMessage
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
    );
  }
}
