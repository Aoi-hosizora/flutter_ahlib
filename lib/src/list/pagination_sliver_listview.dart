import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';
import 'package:flutter_ahlib/src/util/flutter_extensions.dart';

/// Pagination [SliverList] is an implementation of [PaginationDataView], with
/// [PlaceholderText], [AppendIndicator], [RefreshIndicator], [Scrollbar].
class PaginationSliverListView<T> extends PaginationDataView<T> {
  const PaginationSliverListView({
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
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.reverse = false,
    this.shrinkWrap = false,
    // ===================================
    this.hasOverlapAbsorber = false,
    this.separator,
    this.innerTopSliver,
    this.innerBottomSliver,
  })  : assert(data != null && strategy != null && (getDataByOffset == null || getDataBySeek == null)),
        assert(strategy != PaginationStrategy.offsetBased || getDataByOffset != null),
        assert(strategy != PaginationStrategy.seekBased || getDataBySeek != null),
        assert(setting != null && paginationSetting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
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
  final UpdatableDataViewSetting setting;

  /// Some pagination settings.
  @override
  final PaginationDataViewSetting paginationSetting;

  /// The controller for [UpdatableDataView].
  @override
  final UpdatableDataViewController controller;

  /// The controller for [CustomScrollView].
  @override
  final ScrollController scrollController;

  /// The itemBuilder for [SliverList].
  @override
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [SliverList].
  @override
  final EdgeInsetsGeometry padding;

  /// The physics for [CustomScrollView].
  @override
  final ScrollPhysics physics;

  /// The reverse for [CustomScrollView].
  @override
  final bool reverse;

  /// The shrinkWrap for [CustomScrollView].
  @override
  final bool shrinkWrap;

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber], if the value is true, you may need to wrap with [Builder].
  final bool hasOverlapAbsorber;

  /// The separator between items in [SliverList].
  final Widget separator;

  /// The widget before [SliverList] in [PlaceholderText].
  final Widget innerTopSliver;

  /// The widget after [SliverList] in [PlaceholderText].
  final Widget innerBottomSliver;

  @override
  _PaginationSliverListViewState<T> createState() => _PaginationSliverListViewState<T>();
}

class _PaginationSliverListViewState<T> extends State<PaginationSliverListView<T>> with AutomaticKeepAliveClientMixin<PaginationSliverListView<T>> {
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
    return widget.getDataCore(
      reset: reset,
      downScrollable: _downScrollable,
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

    var view = CustomScrollView(
      controller: widget.scrollController,
      physics: widget.physics,
      reverse: widget.reverse ?? false,
      shrinkWrap: widget.shrinkWrap ?? false,
      // ===================================
      slivers: [
        if (widget.hasOverlapAbsorber)
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.innerTopSliver != null) widget.innerTopSliver,
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: widget.separator == null
                ? SliverChildBuilderDelegate(
                    (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                    childCount: widget.data.length,
                  )
                : SliverSeparatedBuilderDelegate(
                    (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                    childCount: widget.data.length,
                    separator: widget.separator,
                  ),
          ),
        ),
        if (widget.innerBottomSliver != null) widget.innerBottomSliver,
      ],
    );

    return AppendIndicator(
      key: _appendIndicatorKey,
      onAppend: () => _getData(reset: false),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getData(reset: true),
        child: PlaceholderText.from(
          onRefresh: _refreshIndicatorKey.currentState?.show,
          forceState: _forceState,
          isLoading: _loading,
          isEmpty: widget.data.isEmpty,
          errorText: _errorMessage,
          onChanged: widget.setting.onStateChanged,
          setting: widget.setting.placeholderSetting,
          childBuilder: (c) => NotificationListener<ScrollNotification>(
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
      ),
    );
  }
}
