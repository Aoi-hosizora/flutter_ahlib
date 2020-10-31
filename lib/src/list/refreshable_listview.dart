import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [ListView] with [RefreshIndicator], [PlaceholderText], [Scrollbar].
class RefreshableListView<T> extends StatefulWidget {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.refreshFirst = true,
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
        assert(refreshFirst != null),
        assert(itemBuilder != null),
        super(key: key);

  /// List data, need to create this list outside [RefreshableListView].
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// [ListView] controller, with more helper functions.
  final ScrollMoreController controller;

  /// The itemBuilder for [ListView].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [ListView].
  final EdgeInsetsGeometry padding;

  /// The shrinkWrap for [ListView].
  final bool shrinkWrap;

  /// The physics for [ListView].
  final ScrollPhysics physics;

  /// The reverse for [ListView].
  final bool reverse;

  /// The primary for [ListView].
  final bool primary;

  /// The separator between items in [ListView].
  final Widget separator;

  /// The widget before [ListView].
  final Widget topWidget;

  /// The widget after [ListView].
  final Widget bottomWidget;

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.refreshFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  bool _loading = true;
  String _errorMessage;

  Future<void> _getData() async {
    // start loading
    _loading = true;
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data with no error
      _errorMessage = null;
      widget.data.clear();
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 20)); // must delayed
      widget.data.addAll(list); // replace to the new list
    }).catchError((e) {
      // error aroused, record the message
      _errorMessage = e.toString();
    }).whenComplete(() {
      // finish loading and setState
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
            if (widget.topWidget != null) widget.topWidget,
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
            if (widget.bottomWidget != null) widget.bottomWidget,
          ],
        ),
      ),
    );
  }
}
