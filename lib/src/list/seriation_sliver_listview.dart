import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/common/placeholder_text.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// Appendable series `SliverListView` which packing `AppendIndicator`, `RefreshIndicator`, `PlaceholderText`, `Scrollbar` and `SliverList`
class SeriationSliverListView<T, U> extends StatefulWidget {
  const SeriationSliverListView({
    Key key,
    @required this.data,
    @required this.getData,
    @required this.nothingMaxId,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    this.innerController,
    @required this.itemBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.separator,
    this.topSliver,
    this.bottomSliver,
  })  : assert(data != null),
        assert(getData != null),
        assert(controller == null || innerController != null),
        assert(itemBuilder != null),
        super(key: key);

  final List<T> data;
  final GetSeriesDataFunction<T, U> getData;
  final U nothingMaxId;
  final PlaceholderStateChangedCallback onStateChanged;
  final PlaceholderSetting placeholderSetting;
  final ScrollMoreController controller;
  final ScrollController innerController;
  final Widget Function(BuildContext, T) itemBuilder;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool reverse;
  final Widget separator;
  final Widget topSliver;
  final Widget bottomSliver;
  @override
  _SeriationSliverListViewState<T, U> createState() => _SeriationSliverListViewState<T, U>();
}

class _SeriationSliverListViewState<T, U> extends State<SeriationSliverListView<T, U>>
    with AutomaticKeepAliveClientMixin<SeriationSliverListView<T, U>> {
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

    widget.controller?.bind(() => widget.innerController);
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
          childBuilder: (c) => Scrollbar(
            child: CustomScrollView(
              controller: widget.innerController,
              shrinkWrap: widget.shrinkWrap ?? false,
              physics: widget.physics,
              reverse: widget.reverse ?? false,
              slivers: [
                widget.topSliver ?? SliverToBoxAdapter(),
                SliverPadding(
                  padding: widget.padding,
                  sliver: SliverList(
                    delegate: widget.separator == null
                        ? SliverChildBuilderDelegate(
                            (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                            childCount: widget.data.length,
                          )
                        : SliverChildBuilderDelegate(
                            (c, idx) => idx % 2 == 0
                                ? widget.itemBuilder(
                                    c,
                                    widget.data[idx ~/ 2],
                                  )
                                : widget.separator,
                            childCount: widget.data.length * 2 - 1,
                          ),
                  ),
                ),
                widget.bottomSliver ?? SliverToBoxAdapter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}