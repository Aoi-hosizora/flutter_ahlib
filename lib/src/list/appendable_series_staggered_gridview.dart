import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/list/type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Appendable series `StaggeredGridView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class AppendableSeriesStaggeredGridView<T, U> extends StatefulWidget {
  const AppendableSeriesStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    @required this.nothingMaxId,
    this.onStateChanged,
    this.placeholdetSetting,
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
  final GetSeriesDataFunction<T, U> getData;
  final U nothingMaxId;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholdetSetting;
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
  _AppendableSeriesStaggeredGridViewState<T, U> createState() => _AppendableSeriesStaggeredGridViewState<T, U>();
}

class _AppendableSeriesStaggeredGridViewState<T, U> extends State<AppendableSeriesStaggeredGridView<T, U>>
    with AutomaticKeepAliveClientMixin<AppendableSeriesStaggeredGridView<T, U>> {
  @override
  bool get wantKeepAlive => true;

  // copy of widget.controller or new controller
  ScrollMoreController _controller;
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  // id data, last id data, error message
  U _maxId, _lastMaxId;
  bool _loading = true;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
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

  Future<void> _getData({@required bool reset}) async {
    if (reset) {
      _maxId = null;
      _lastMaxId = null;
    }

    // has no next
    if (widget.nothingMaxId == _maxId) {
      return;
    }

    // start refresh
    final func = widget.getData(maxId: _maxId);
    _loading = true;
    if (mounted) setState(() {});

    return func.then((data) async {
      // success to get data, update maxId, empty errorMessage
      _lastMaxId = _maxId;
      _maxId = data.maxId;
      _errorMessage = null;
      if (reset) {
        widget.data.clear();
        if (mounted) setState(() {});
        await Future.delayed(Duration(milliseconds: 20)); // must delayed
        widget.data.addAll(data.data);
      } else {
        widget.data.addAll(data.data); // append directly
        _controller.scrollDown();
      }
      if (data.data.length == 0) {
        _maxId = _lastMaxId; // not next, problem!!!!!!
      }
    }).catchError((e) {
      // error arowsed, restore last maxId
      _errorMessage = e.toString();
      _maxId = _lastMaxId;
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
          setting: widget.placeholdetSetting,
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
      ),
    );
  }
}
