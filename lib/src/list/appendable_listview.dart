import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// Appendable `ListView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `ListView`
class AppendableListView<T> extends StatefulWidget {
  const AppendableListView({
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
  final GetPageDataFunction<T> getData;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholdetSetting;
  final EdgeInsetsGeometry padding;
  final Widget separator;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollMoreController controller;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _AppendableListViewState<T> createState() => _AppendableListViewState<T>();
}

class _AppendableListViewState<T> extends State<AppendableListView<T>> with AutomaticKeepAliveClientMixin<AppendableListView<T>> {
  @override
  bool get wantKeepAlive => true;

  // copy of widget.controller or new controller
  ScrollMoreController _controller;
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
        _controller.scrollDown();
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
