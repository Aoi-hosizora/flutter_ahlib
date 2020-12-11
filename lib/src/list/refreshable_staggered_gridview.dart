import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_list_func.dart';
import 'package:flutter_ahlib/src/list/updatable_list_controller.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Refreshable [StaggeredGridView] is a kind of updatable list, with
/// [PlaceholderText], [RefreshIndicator], [Scrollbar] and [StaggeredGridView].
class RefreshableStaggeredGridView<T> extends StatefulWidget {
  const RefreshableStaggeredGridView({
    Key key,
    // parameter for updatable list
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableListSetting(),
    this.controller,
    // parameter for list view
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
    // parameter for extra columns
    this.innerCrossAxisAlignment,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outerCrossAxisAlignment,
    this.outerTopWidget,
    this.outerBottomWidget,
    // end of parameter
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null && crossAxisCount != null),
        super(key: key);

  // parameter for updatable list

  /// List data, need to create this outside.
  final List<T> data;

  /// Function to get list data.
  final Future<List<T>> Function() getData;

  /// Setting of updatable list.
  final UpdatableListSetting setting;

  /// Updatable list controller, with [UpdatableListController].
  final UpdatableListController controller;

  // parameter for list view

  /// The controller for [StaggeredGridView].
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

  // parameter for extra columns

  /// The crossAxisAlignment for [Column] in [PlaceholderText].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The widget before inner [StaggeredGridView].
  final Widget innerTopWidget;

  /// The widget after inner [StaggeredGridView].
  final Widget innerBottomWidget;

  /// The crossAxisAlignment for outer [Column].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [ListView] out of [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [ListView] out of [PlaceholderText].
  final Widget outerBottomWidget;

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
    _forceState = null;
    return getRefreshableDataFunc(
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setting: widget.setting,
      data: widget.data,
      getData: widget.getData,
      setState: () {
        if (mounted) setState(() {});
      },
    );
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
        crossAxisAlignment: widget.outerCrossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (widget.outerTopWidget != null) widget.outerTopWidget,
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
          if (widget.outerBottomWidget != null) widget.outerBottomWidget,
        ],
      ),
    );
  }
}
