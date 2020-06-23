import 'package:flutter/material.dart';
import 'package:flutter_ahlib/list/placeholder_text.dart';
import 'package:flutter_ahlib/list/scroll_more_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef GetNonPageDataFunction<T> = Future<List<T>> Function();

class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStateChanged,
    this.padding,
    @required this.itemBuilder,
    this.controller,
    this.topWidget,
    this.bottomWidget,
    this.primary,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    @required this.crossAxisCount,
    @required this.staggeredTileBuilder,
  })  : assert(data != null),
        assert(getData != null),
        assert(itemBuilder != null),
        assert(crossAxisCount != null),
        assert(staggeredTileBuilder != null),
        super(key: key);

  final List<T> data;
  final GetNonPageDataFunction<T> getData;
  final StateChangedCallback onStateChanged;
  final EdgeInsetsGeometry padding;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollMoreController controller;
  final Widget topWidget;
  final Widget bottomWidget;

  final bool primary;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final StaggeredTile Function(int) staggeredTileBuilder;

  @override
  _RefreshableStaggeredGridViewState<T> createState() => _RefreshableStaggeredGridViewState<T>();
}

class _RefreshableStaggeredGridViewState<T> extends State<RefreshableStaggeredGridView<T>>
    with AutomaticKeepAliveClientMixin<RefreshableStaggeredGridView<T>> {
  @override
  bool get wantKeepAlive => true;

  ScrollMoreController _controller;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _loading = false;
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
    final func = widget.getData();
    _loading = true;
    if (mounted) {
      setState(() {});
    }
    return func.then((List<T> list) async {
      _errorMessage = null;
      widget.data.clear();
      if (mounted) {
        setState(() {});
      }
      await Future.delayed(Duration(milliseconds: 20));
      widget.data.addAll(list);
    }).catchError((e) {
      _errorMessage = e.toString();
    }).whenComplete(() {
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: ListPlaceHolderText.from(
        onRefresh: _refreshIndicatorKey.currentState?.show,
        isLoading: _loading,
        errorText: _errorMessage,
        isEmpty: widget.data.isEmpty,
        onChanged: widget.onStateChanged,
        child: Column(
          children: [
            widget.topWidget ?? SizedBox(height: 0),
            Expanded(
              child: Scrollbar(
                child: StaggeredGridView.countBuilder(
                  controller: _controller,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: widget.padding,
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
