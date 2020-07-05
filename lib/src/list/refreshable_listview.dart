import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// Refreshable `ListView` which packing `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class RefreshableListView<T> extends StatefulWidget {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
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
  final GetNonPageDataFunction<T> getData;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholdetSetting;
  final EdgeInsetsGeometry padding;
  final Widget separator;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollMoreController controller;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>>
    with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
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
    );
  }
}
