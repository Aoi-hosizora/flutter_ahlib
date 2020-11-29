import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [ListView] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableListView<T> extends StatefulWidget {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onAppend,
    this.onError,
    this.clearWhenRefreshing = false,
    this.clearWhenError = false,
    this.refreshFirst = true,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    @required this.itemBuilder,
    this.separator,
    this.separatorBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.topWidget,
    this.bottomWidget,
  })  : assert(data != null),
        assert(getData != null),
        assert(clearWhenRefreshing != null),
        assert(clearWhenError != null),
        assert(refreshFirst != null),
        assert(itemBuilder != null),
        super(key: key);

  /// List data, need to create this outside.
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Callback when data has been appended.
  final void Function(List<T>) onAppend;

  /// Callback when error invoked.
  final void Function(dynamic) onError;

  /// Clear list when refreshing data.
  final bool clearWhenRefreshing;

  /// Clear list when error aroused.
  final bool clearWhenError;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// [ListView] controller, with [ScrollMoreController].
  final ScrollMoreController controller;

  /// The itemBuilder for [ListView].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator between items in [ListView].
  final Widget separator;

  /// The separatorBuilder for [ListView].
  final Widget Function(BuildContext, int) separatorBuilder;

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

  /// The mainAxisAlignment for [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The mainAxisSize for [Column].
  final MainAxisSize mainAxisSize;

  /// The crossAxisAlignment for [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The widget before [ListView].
  final Widget topWidget;

  /// The widget after [ListView].
  final Widget bottomWidget;

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.refreshFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  Future<void> _getData() async {
    // start loading
    _loading = true;
    if (widget.clearWhenRefreshing) {
      _errorMessage = '';
      widget.data.clear();
    }
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      widget.data.clear();
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 20));
      widget.data.addAll(list);
      widget.onAppend?.call(list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
      if (widget.clearWhenError) {
        widget.data.clear();
      }
      widget.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PlaceholderText.from(
      onRefresh: _refreshIndicatorKey.currentState?.show,
      isLoading: _loading,
      isEmpty: widget.data.isEmpty,
      errorText: _errorMessage,
      onChanged: widget.onStateChanged,
      setting: widget.placeholderSetting,
      childBuilder: (c) => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(),
        child: Column(
          mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (widget.topWidget != null) widget.topWidget,
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  controller: widget.controller,
                  padding: widget.padding,
                  shrinkWrap: widget.shrinkWrap ?? false,
                  physics: widget.physics,
                  reverse: widget.reverse ?? false,
                  itemCount: widget.data.length,
                  separatorBuilder: widget.separatorBuilder ?? (c, idx) => widget.separator ?? SizedBox(height: 0),
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
