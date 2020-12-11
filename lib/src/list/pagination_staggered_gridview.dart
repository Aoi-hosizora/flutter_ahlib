import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// Pagination [StaggeredGridView] is an implementation of [PaginationDataView], with
/// [PlaceholderText], [AppendIndicator], [RefreshIndicator], [Scrollbar].
class PaginationStaggeredGridView<T> extends PaginationDataView<T> {
  const PaginationStaggeredGridView({
    Key key,
    @required this.data,
    @required this.strategy,
    this.getDataByOffset,
    this.getDataBySeek,
    this.setting = const UpdatableDataViewSetting(),
    this.paginationSetting = const PaginationDataViewSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    this.padding,
    this.physics,
    this.reverse,
    this.shrinkWrap,
    @required this.staggeredTileBuilder,
    @required this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.innerCrossAxisAlignment,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outerCrossAxisAlignment,
    this.outerTopWidget,
    this.outerBottomWidget,
  })  : assert(data != null && strategy != null && (getDataByOffset == null || getDataBySeek == null)),
        assert(strategy != PaginationStrategy.offsetBased || getDataByOffset != null),
        assert(strategy != PaginationStrategy.seekBased || getDataBySeek != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        assert(staggeredTileBuilder != null && crossAxisCount != null),
        super(key: key);

  /// List data, need to create this outside.
  @override
  final List<T> data;

  /// The pagination strategy for [PaginationDataView].
  @override
  final PaginationStrategy strategy;

  /// Function to get list data when used [PaginationStrategy.offsetBased].
  @override
  final Future<List<T>> Function({int page}) getDataByOffset;

  /// Function to get list data when used [PaginationStrategy.seekBased].
  @override
  final Future<SeekList<T>> Function({dynamic maxId}) getDataBySeek;

  /// The setting for [UpdatableDataView].
  @override
  final UpdatableDataViewSetting setting;

  /// The pagination setting for [PaginationDataView].
  @override
  final PaginationDataViewSetting paginationSetting;

  /// The controller for [UpdatableDataView].
  @override
  final UpdatableDataViewController controller;

  /// The controller for [StaggeredGridView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [StaggeredGridView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [StaggeredGridView].
  @override
  final EdgeInsetsGeometry padding;

  /// The physics for [StaggeredGridView].
  @override
  final ScrollPhysics physics;

  /// The reverse for [StaggeredGridView].
  @override
  final bool reverse;

  /// The shrinkWrap for [StaggeredGridView].
  @override
  final bool shrinkWrap;

  /// The staggeredTileBuilder for [StaggeredGridView].
  final StaggeredTile Function(int) staggeredTileBuilder;

  /// The crossAxisCount for [StaggeredGridView].
  final int crossAxisCount;

  /// The mainAxisSpacing for [StaggeredGridView].
  final double mainAxisSpacing;

  /// The crossAxisSpacing for [StaggeredGridView]
  final double crossAxisSpacing;

  /// The crossAxisAlignment for inner [Column].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The widget before [StaggeredGridView] in [PlaceholderText].
  final Widget innerTopWidget;

  /// The widget after [StaggeredGridView] in [PlaceholderText].
  final Widget innerBottomWidget;

  /// The crossAxisAlignment for outer [Column].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [StaggeredGridView] out of [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [StaggeredGridView] out of [PlaceholderText].
  final Widget outerBottomWidget;

  @override
  _PaginationStaggeredGridViewState<T> createState() => _PaginationStaggeredGridViewState<T>();
}

class _PaginationStaggeredGridViewState<T> extends State<PaginationStaggeredGridView<T>> with AutomaticKeepAliveClientMixin<PaginationStaggeredGridView<T>> {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  PlaceholderState _forceState;
  var _loading = false;
  var _errorMessage = '';
  int _nextPage;
  dynamic _nextMaxId;

  @override
  void initState() {
    super.initState();
    _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);
    _nextPage = widget.paginationSetting.initialPage;
    _nextMaxId = widget.paginationSetting.initialMaxId;
  }

  @override
  void dispose() {
    widget.controller?.detachAppend();
    widget.controller?.detachRefresh();
    super.dispose();
  }

  Future<void> _getData({@required bool reset}) async {
    _forceState = null;
    return widget.getDataCore(
      reset: reset,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setNextPage: (p) => _nextPage = p,
      setNextMaxId: (m) => _nextMaxId = m,
      getNextPage: () => _nextPage,
      getNextMaxId: () => _nextMaxId,
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
    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
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
                          physics: widget.physics,
                          reverse: widget.reverse ?? false,
                          shrinkWrap: widget.shrinkWrap ?? false,
                          // ===================================
                          staggeredTileBuilder: widget.staggeredTileBuilder,
                          crossAxisCount: widget.crossAxisCount,
                          mainAxisSpacing: widget.mainAxisSpacing ?? 0,
                          crossAxisSpacing: widget.crossAxisSpacing ?? 0,
                          // ===================================
                          itemCount: widget.data.length,
                          itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
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
      ),
    );
  }
}
