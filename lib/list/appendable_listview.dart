import 'package:flutter_ahlib/list/append_indicator.dart';
import 'package:flutter_ahlib/list/placeholder_text.dart';
import 'package:flutter_ahlib/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';

typedef GetPageDataFunction<T> = Future<List<T>> Function({int page});

class AppendableListView<T> extends StatefulWidget {
  const AppendableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStateChanged,
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
  final StateChangedCallback onStateChanged;
  final EdgeInsetsGeometry padding;
  final Widget separator;
  final Widget Function(BuildContext, T) itemBuilder;
  final ScrollMoreController controller;
  final Widget topWidget;
  final Widget bottomWidget;

  @override
  _AppendableListViewState<T> createState() => _AppendableListViewState<T>();
}

class _AppendableListViewState<T> extends State<AppendableListView<T>>
    with AutomaticKeepAliveClientMixin<AppendableListView<T>> {
  @override
  bool get wantKeepAlive => true;

  ScrollMoreController _controller;
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  int _page = 0;
  bool _loading = false;
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
      _page = 0;
    }
    _page++;

    final func = widget.getData(page: _page);
    _loading = true;
    if (mounted) {
      setState(() {});
    }
    return func.then((List<T> list) async {
      _errorMessage = null;
      if (reset) {
        widget.data.clear();
        if (mounted) {
          setState(() {});
        }
        await Future.delayed(Duration(milliseconds: 20));
        widget.data.addAll(list);
      } else {
        widget.data.addAll(list);
        _controller.scrollDown();
      }
      if (list.length == 0) {
        _page--;
      }
    }).catchError((e) {
      _errorMessage = e.toString();
      _page--;
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
    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
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
