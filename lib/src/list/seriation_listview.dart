import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

/// Appendable series `ListView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class SeriationListView<T, U> extends StatefulWidget {
  const SeriationListView({
    Key key,
    @required this.data,
    @required this.getData,
    @required this.nothingMaxId,
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
  final PlaceholderSetting placeholderSetting;
  final ScrollMoreController controller;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool reverse;
  final bool primary;
  final Widget separator;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _SeriationListViewState<T, U> createState() => _SeriationListViewState<T, U>();
}

class _SeriationListViewState<T, U> extends State<SeriationListView<T, U>>
    with AutomaticKeepAliveClientMixin<SeriationListView<T, U>> {
  @override
  bool get wantKeepAlive => true;

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

    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
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
        widget.controller?.scrollDown();
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
                  child: ListView.separated(
                    controller: widget.controller,
                    shrinkWrap: widget.shrinkWrap ?? false,
                    physics: widget.physics,
                    reverse: widget.reverse ?? false,
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
