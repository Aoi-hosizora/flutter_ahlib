import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Refreshable [StaggeredGridView] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
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
    @required this.staggeredTileBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    @required this.crossAxisCount,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
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
        assert(staggeredTileBuilder != null),
        assert(crossAxisCount != null),
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

  /// [StaggeredGridView] controller, with [ScrollMoreController].
  final ScrollMoreController controller;

  /// The itemBuilder for [StaggeredGridView].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The staggeredTileBuilder for [StaggeredGridView].
  final StaggeredTile Function(int) staggeredTileBuilder;

  /// The padding for [StaggeredGridView].
  final EdgeInsetsGeometry padding;

  /// The shrinkWrap for [StaggeredGridView].
  final bool shrinkWrap;

  /// The physics for [StaggeredGridView].
  final ScrollPhysics physics;

  /// The reverse for [StaggeredGridView].
  final bool reverse;

  /// The primary for [StaggeredGridView].
  final bool primary;

  /// The crossAxisCount for [StaggeredGridView].
  final int crossAxisCount;

  /// The crossAxisSpacing for [StaggeredGridView].
  final double crossAxisSpacing;

  /// The mainAxisSpacing for [StaggeredGridView].
  final double mainAxisSpacing;

  /// The mainAxisAlignment for [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The mainAxisSize for [Column].
  final MainAxisSize mainAxisSize;

  /// The crossAxisAlignment for [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The widget before [StaggeredGridView].
  final Widget topWidget;

  /// The widget after [StaggeredGridView].
  final Widget bottomWidget;

  @override
  _RefreshableStaggeredGridViewState<T> createState() => _RefreshableStaggeredGridViewState<T>();
}

class _RefreshableStaggeredGridViewState<T> extends State<RefreshableStaggeredGridView<T>> with AutomaticKeepAliveClientMixin<RefreshableStaggeredGridView<T>> {
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
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
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
                child: StaggeredGridView.countBuilder(
                  controller: widget.controller,
                  padding: widget.padding,
                  shrinkWrap: widget.shrinkWrap ?? false,
                  physics: widget.physics,
                  reverse: widget.reverse ?? false,
                  primary: widget.primary,
                  crossAxisSpacing: widget.crossAxisSpacing,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  crossAxisCount: widget.crossAxisCount,
                  staggeredTileBuilder: widget.staggeredTileBuilder,
                  itemCount: widget.data.length,
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
