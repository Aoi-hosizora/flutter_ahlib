import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

/// data model for `AppendableSeriesListView`
class PageData<T, U> {
  List<T> data;
  U maxId;

  PageData({this.data, this.maxId});
}

/// appendable ListView which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class AppendableSeriesListView<T, U> extends StatefulWidget {
  const AppendableSeriesListView({
    Key key,
    @required this.data,
    @required this.getData,
    @required this.nothingMaxId,
    this.onStateChanged,
    this.placeholdetSetting,
    this.padding,
    this.separator,
    @required this.itemBuilder,
    this.controller,
    this.topWidget,
    this.bottomWidget,
  })  : assert(data != null),
        assert(getData != null),
        assert(itemBuilder != null),
        super(key: key);

  final List<T> data;
  final GetSeriesDataFunction<T, U> getData;
  final U nothingMaxId;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholdetSetting;
  final EdgeInsetsGeometry padding;
  final Widget separator;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollMoreController controller;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _AppendableSeriesListViewState<T, U> createState() => _AppendableSeriesListViewState<T, U>();
}

class _AppendableSeriesListViewState<T, U> extends State<AppendableSeriesListView<T, U>>
    with AutomaticKeepAliveClientMixin<AppendableSeriesListView<T, U>> {
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
    _controller.attachAppend(_appendIndicatorKey);
    _controller.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    if (_controller != widget.controller) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _getData({bool reset}) async {
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
                  child: ListView.separated(
                    controller: _controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: widget.padding,
                    itemCount: widget.data.length,
                    separatorBuilder: (c, idx) => widget.separator ?? SizedBox(height: 0),
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
