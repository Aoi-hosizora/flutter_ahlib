import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';

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
    this.paginationSetting = const PaginationSetting(),
    this.controller,
    this.scrollController,
    @required this.itemBuilder,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.reverse = false,
    this.shrinkWrap = false,
    // ===================================
    this.separator,
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.outerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outerTopWidget,
    this.outerBottomWidget,
  })  : assert(data != null && strategy != null && (getDataByOffset == null || getDataBySeek == null)),
        assert(strategy != PaginationStrategy.offsetBased || getDataByOffset != null),
        assert(strategy != PaginationStrategy.seekBased || getDataBySeek != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        assert(separator == null),
        super(key: key);

  /// The list of scored data, need to be created out of widget.
  @override
  final List<T> data;

  /// The pagination strategy.
  @override
  final PaginationStrategy strategy;

  /// Function to get list data when used [PaginationStrategy.offsetBased].
  @override
  final Future<List<T>> Function({int page}) getDataByOffset;

  /// Function to get list data when used [PaginationStrategy.seekBased].
  @override
  final Future<SeekList<T>> Function({dynamic maxId}) getDataBySeek;

  /// Some behavior and display settings.
  @override
  final UpdatableDataViewSetting<T> setting;

  /// Some pagination settings.
  @override
  final PaginationSetting paginationSetting;

  /// The controller of the behavior.
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

  /// The crossAxisAlignment for inner [Column] in [PlaceholderText].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The crossAxisAlignment for outer [Column] out of [PlaceholderText].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [ListView] in [PlaceholderText].
  final Widget innerTopWidget;

  /// The widget after [ListView] in [PlaceholderText].
  final Widget innerBottomWidget;

  /// The widget before [ListView] out of [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [ListView] out of [PlaceholderText].
  final Widget outerBottomWidget;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
  final _appendIndicatorKey = GlobalKey<AppendIndicatorState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _downScrollable = false;
  PlaceholderState _forceState;
  var _loading = false;
  var _errorMessage = '';
  int _nextPage;
  dynamic _nextMaxId;

  @override
  void initState() {
    super.initState();
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

  bool _onScroll(ScrollNotification s) {
    _downScrollable = !s.metrics.isShortScroll() && s.metrics.isInBottom();
    return false;
  }

  Future<void> _getData({@required bool reset}) async {
    _forceState = null;
    if (reset) {
      widget.setting.onRefresh?.call();
    }
    return widget.getDataCore(
      reset: reset,
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
      setNextPage: (p) => _nextPage = p,
      setNextMaxId: (m) => _nextMaxId = m,
      getNextPage: () => _nextPage,
      getNextMaxId: () => _nextMaxId,
      getDownScrollable: () => _downScrollable,
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

    var view = ListView.separated(
      controller: widget.scrollController,
      padding: widget.padding,
      physics: widget.physics,
      reverse: widget.reverse ?? false,
      shrinkWrap: widget.shrinkWrap ?? false,
      // ===================================
      separatorBuilder: (c, idx) => widget.separator ?? SizedBox(height: 0),
      itemCount: widget.data.length,
      itemBuilder: (c, idx) => widget.itemBuilder(c, widget.data[idx]),
    );

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
                onRefresh: () => _refreshIndicatorKey.currentState?.show(),
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
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (s) => _onScroll(s),
                        child: widget.setting.showScrollbar
                            ? Scrollbar(
                                thickness: widget.setting.scrollbarThickness,
                                radius: widget.setting.scrollbarRadius,
                                child: view,
                              )
                            : view,
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
