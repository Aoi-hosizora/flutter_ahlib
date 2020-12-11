import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Pagination [ListView] is an implementation of [PaginationDataView], with
/// [PlaceholderText], [AppendIndicator], [RefreshIndicator], [Scrollbar] and [ListView].
class PaginationListView<T> extends PaginationDataView<T> {
  const PaginationListView({
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
    this.separator,
    this.separatorBuilder,
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
        assert(separator == null || separatorBuilder == null),
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

  /// The controller for [ListView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [ListView].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [ListView].
  @override
  final EdgeInsetsGeometry padding;

  /// The physics for [ListView].
  @override
  final ScrollPhysics physics;

  /// The reverse for [ListView].
  @override
  final bool reverse;

  /// The shrinkWrap for [ListView].
  @override
  final bool shrinkWrap;

  /// The separator between items in [ListView].
  final Widget separator;

  /// The separatorBuilder for [ListView].
  final Widget Function(BuildContext, int) separatorBuilder;

  /// The crossAxisAlignment for inner [Column].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The widget before [ListView] in [PlaceholderText].
  final Widget innerTopWidget;

  /// The widget after [ListView] in [PlaceholderText].
  final Widget innerBottomWidget;

  /// The crossAxisAlignment for outer [Column].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [ListView] out of [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [ListView] out of [PlaceholderText].
  final Widget outerBottomWidget;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
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
                        child: ListView.separated(
                          // ===================================
                          controller: widget.scrollController,
                          padding: widget.padding,
                          physics: widget.physics,
                          reverse: widget.reverse ?? false,
                          shrinkWrap: widget.shrinkWrap ?? false,
                          // ===================================
                          separatorBuilder: widget.separatorBuilder ?? (c, idx) => widget.separator ?? SizedBox(height: 0),
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
      ),
    );
  }
}
