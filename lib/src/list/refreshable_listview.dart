import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [ListView] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableListView<T> extends StatefulWidget {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.onStartLoading,
    this.onStopLoading,
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
    this.outMainAxisAlignment,
    this.outMainAxisSize,
    this.outCrossAxisAlignment,
    this.outTopWidget,
    this.outBottomWidget,
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

  /// Callback when start loading.
  final void Function() onStartLoading;

  /// Callback when stop loading.
  final void Function() onStopLoading;

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

  /// The physics for inner [ListView].
  final ScrollPhysics physics;

  /// The reverse for inner [ListView].
  final bool reverse;

  /// The primary for inner [ListView].
  final bool primary;

  /// The mainAxisAlignment for inner [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The mainAxisSize for inner [Column].
  final MainAxisSize mainAxisSize;

  /// The crossAxisAlignment for inner [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The widget before [ListView] in [PlaceholderText].
  final Widget topWidget;

  /// The widget after [ListView] in [PlaceholderText].
  final Widget bottomWidget;

  /// The mainAxisAlignment for outer [Column].
  final MainAxisAlignment outMainAxisAlignment;

  /// The mainAxisSize for outer [Column].
  final MainAxisSize outMainAxisSize;

  /// The crossAxisAlignment for outer [Column].
  final CrossAxisAlignment outCrossAxisAlignment;

  /// The widget before [ListView] out of [PlaceholderText].
  final Widget outTopWidget;

  /// The widget after [ListView] out of [PlaceholderText].
  final Widget outBottomWidget;

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  PlaceholderState _forceState;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.refreshFirst) {
      _forceState = PlaceholderState.loading;
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
    widget.onStartLoading?.call();
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      if (widget.data.isNotEmpty) {
        widget.data.clear();
        if (mounted) setState(() {});
        await Future.delayed(Duration(milliseconds: 20));
      }
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
      widget.onStopLoading?.call();
      if (mounted) setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: Column(
        mainAxisAlignment: widget.outMainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: widget.outMainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment: widget.outCrossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (widget.outTopWidget != null) widget.outTopWidget,
          Expanded(
            child: PlaceholderText.from(
              onRefresh: _refreshIndicatorKey.currentState?.show,
              forceState: _forceState,
              isLoading: _loading,
              isEmpty: widget.data.isEmpty,
              errorText: _errorMessage,
              onChanged: widget.onStateChanged,
              setting: widget.placeholderSetting,
              childBuilder: (c) => Column(
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
          ),
          if (widget.outBottomWidget != null) widget.outBottomWidget,
        ],
      ),
    );
  }
}
