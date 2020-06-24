import 'package:flutter_ahlib/list/placeholder_text.dart';
import 'package:flutter_ahlib/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';

typedef GetNonPageDataFunction<T> = Future<List<T>> Function();

class RefreshableListView<T> extends StatefulWidget {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStateChanged,
    this.placeholderText,
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
  final StateChangedCallback onStateChanged;
  final ListPlaceHolderSetting placeholderText;
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
        placeholderText: widget.placeholderText,
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
