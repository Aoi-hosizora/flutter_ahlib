import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_list_controller.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Refreshable [StaggeredGridView] with [PlaceholderText], [RefreshIndicator], [Scrollbar].
class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableListSetting(),
    this.controller,
    //
    this.scrollController,
    @required this.itemBuilder,
    this.padding,
    this.physics,
    this.reverse,
    this.shrinkWrap,
    @required this.staggeredTileBuilder,
    @required this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    //
    this.innerMainAxisAlignment,
    this.innerMainAxisSize,
    this.innerCrossAxisAlignment,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outMainAxisAlignment,
    this.outMainAxisSize,
    this.outCrossAxisAlignment,
    this.outTopWidget,
    this.outBottomWidget,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null && crossAxisCount != null),
        super(key: key);

  /// List data, need to create this outside.
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Setting of updatable list.
  final UpdatableListSetting setting;

  /// Updatable list controller, with [UpdatableListController].
  final UpdatableListController controller;

  //

  /// The controller for [ListView].
  final ScrollController scrollController;

  /// The itemBuilder for [StaggeredGridView].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [StaggeredGridView].
  final EdgeInsetsGeometry padding;

  /// The physics for [StaggeredGridView].
  final ScrollPhysics physics;

  /// The reverse for [StaggeredGridView].
  final bool reverse;

  /// The shrinkWrap for [StaggeredGridView].
  final bool shrinkWrap;

  /// The staggeredTileBuilder for [StaggeredGridView].
  final StaggeredTile Function(int) staggeredTileBuilder;

  /// The crossAxisCount for [StaggeredGridView].
  final int crossAxisCount;

  /// The crossAxisSpacing for [StaggeredGridView]
  final double crossAxisSpacing;

  /// The mainAxisSpacing for [StaggeredGridView].
  final double mainAxisSpacing;

  //

  /// The mainAxisAlignment for [Column] in [PlaceholderText].
  final MainAxisAlignment innerMainAxisAlignment;

  /// The mainAxisSize for [Column] in [PlaceholderText].
  final MainAxisSize innerMainAxisSize;

  /// The crossAxisAlignment for [Column] in [PlaceholderText].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The widget before inner [StaggeredGridView].
  final Widget innerTopWidget;

  /// The widget after inner [StaggeredGridView].
  final Widget innerBottomWidget;

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
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  Future<void> _getData() async {
    // start loading
    _loading = true;
    _forceState = null;
    if (widget.setting.clearWhenRefresh) {
      _errorMessage = '';
      widget.data.clear();
    }
    widget.setting.onStartLoading?.call();
    if (mounted) setState(() {});

    // get data
    final func = widget.getData();

    // return future
    return func.then((List<T> list) async {
      // success to get data without error
      _errorMessage = '';
      if (widget.setting.updateOnlyIfNotEmpty && list.isEmpty) {
        return; // get an empty list
      }
      if (widget.data.isNotEmpty) {
        widget.data.clear();
        if (mounted) setState(() {});
        await Future.delayed(Duration(milliseconds: 20));
      }
      widget.data.addAll(list);
      widget.setting.onAppend?.call(list);
    }).catchError((e) {
      // error aroused
      _errorMessage = e.toString();
      if (widget.setting.clearWhenError) {
        widget.data.clear();
      }
      widget.setting.onError?.call(e);
    }).whenComplete(() {
      // finish loading and setState
      _loading = false;
      widget.setting.onStopLoading?.call();
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
              onChanged: widget.setting.onStateChanged,
              setting: widget.setting.placeholderSetting,
              childBuilder: (c) => Column(
                mainAxisAlignment: widget.innerMainAxisAlignment ?? MainAxisAlignment.start,
                mainAxisSize: widget.innerMainAxisSize ?? MainAxisSize.max,
                crossAxisAlignment: widget.innerCrossAxisAlignment ?? CrossAxisAlignment.center,
                children: [
                  if (widget.innerTopWidget != null) widget.innerTopWidget,
                  Expanded(
                    child: Scrollbar(
                      child: StaggeredGridView.countBuilder(
                        // ===================================
                        controller: widget.scrollController,
                        padding: widget.padding,
                        // ===================================
                        physics: widget.physics,
                        shrinkWrap: widget.shrinkWrap ?? false,
                        reverse: widget.reverse ?? false,
                        // ===================================
                        staggeredTileBuilder: widget.staggeredTileBuilder,
                        crossAxisCount: widget.crossAxisCount,
                        mainAxisSpacing: widget.mainAxisSpacing ?? 0,
                        crossAxisSpacing: widget.crossAxisSpacing ?? 0,
                        // ===================================
                        itemCount: widget.data.length,
                        itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                        // ===================================
                      ),
                    ),
                  ),
                  if (widget.innerBottomWidget != null) widget.innerBottomWidget,
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
