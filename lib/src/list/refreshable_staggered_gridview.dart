import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Refreshable [StaggeredGridView] with [RefreshIndicator], [PlaceholderText], [Scrollbar].
class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
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
    this.topWidget,
    this.bottomWidget,
  })  : assert(data != null),
        assert(getData != null),
        assert(refreshFirst != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null),
        assert(crossAxisCount != null),
        super(key: key);

  /// List data, need to create this list outside [RefreshableStaggeredGridView].
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// [StaggeredGridView] controller, with more helper functions.
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

  /// The widget before [StaggeredGridView].
  final Widget topWidget;

  /// The widget after [StaggeredGridView].
  final Widget bottomWidget;

  @override
  _RefreshableStaggeredGridViewState<T> createState() => _RefreshableStaggeredGridViewState<T>();
}

class _RefreshableStaggeredGridViewState<T> extends State<RefreshableStaggeredGridView<T>> with AutomaticKeepAliveClientMixin<RefreshableStaggeredGridView<T>> {
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

  bool _loading = false;
  String _errorMessage;

  Future<void> _getData() async {
    // start loading
    final func = widget.getData();
    _loading = true;
    if (mounted) setState(() {});

    // return future
    return func.then((List<T> list) async {
      // success to get data with no error
      _errorMessage = null;
      widget.data.clear();
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 20)); // must delayed

      // set to the new list
      widget.data.addAll(list);
    }).catchError((e) {
      // error aroused
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
