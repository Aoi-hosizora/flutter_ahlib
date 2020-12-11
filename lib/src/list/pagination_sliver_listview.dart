import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/scroll_controller_extension.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_list_controller.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Pagination [SliverList] with [PlaceholderText], [AppendIndicator], [RefreshIndicator], [Scrollbar].
class PaginationSliverListView<T> extends StatefulWidget {
  const PaginationSliverListView({
    Key key,
    @required this.data,
    @required this.strategy,
    this.getDataByOffset,
    this.initialPage,
    this.getDataBySeek,
    this.initialMaxId,
    this.nothingMaxId,
    this.onStartLoading,
    this.onStopLoading,
    this.onAppend,
    this.onError,
    this.clearWhenRefreshing = false,
    this.clearWhenError = false,
    this.updateOnlyIfNotEmpty = false,
    this.refreshFirst = true,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    this.scrollController,
    this.hasOverlapAbsorber = false,
    @required this.itemBuilder,
    this.separator,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    this.topSliver,
    this.bottomSliver,
  })  : assert(data != null),
        assert(strategy != PaginationStrategy.offsetBased || getDataByOffset != null),
        assert(strategy != PaginationStrategy.seekBased || getDataBySeek != null),
        assert(clearWhenRefreshing != null),
        assert(clearWhenError != null),
        assert(updateOnlyIfNotEmpty != null),
        assert(refreshFirst != null),
        assert(hasOverlapAbsorber != null),
        assert(itemBuilder != null),
        super(key: key);

  /// List data, need to create this outside.
  final List<T> data;

  /// The pagination strategy.
  final PaginationStrategy strategy;

  /// Function to get list data when used [PaginationStrategy.offsetBased].
  final Future<List<T>> Function({int page}) getDataByOffset;

  /// The initial page value when used [PaginationStrategy.offsetBased].
  final int initialPage;

  /// Function to get list data when used [PaginationStrategy.seekBased].
  final Future<SeekList<T>> Function({dynamic maxId}) getDataBySeek;

  /// The initial maxId value when used [PaginationStrategy.seekBased], nullable.
  final dynamic initialMaxId;

  /// Nothing maxId value when used [PaginationStrategy.seekBased], nullable.
  final dynamic nothingMaxId;

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

  /// If return data is empty, then do nothing, else update list and parameter.
  final bool updateOnlyIfNotEmpty;

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// Updatable list controller, with [UpdatableListController].
  final UpdatableListController controller;

  /// The controller for inner [CustomScrollView].
  final ScrollController scrollController;

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber].
  final bool hasOverlapAbsorber;

  /// The itemBuilder for [SliverChildBuilderDelegate] in [SliverList].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The separator between items in [SliverList].
  final Widget separator;

  /// The padding for [SliverList].
  final EdgeInsetsGeometry padding;

  /// The shrinkWrap for [CustomScrollView].
  final bool shrinkWrap;

  /// The physics for [CustomScrollView].
  final ScrollPhysics physics;

  /// The reverse for [CustomScrollView].
  final bool reverse;

  /// The primary for [CustomScrollView].
  final bool primary;

  /// The widget before [SliverList].
  final Widget topSliver;

  /// The widget after [SliverList].
  final Widget bottomSliver;

  @override
  _PaginationSliverListViewState<T> createState() => _PaginationSliverListViewState<T>();
}

class _PaginationSliverListViewState<T> extends State<PaginationSliverListView<T>> with AutomaticKeepAliveClientMixin<PaginationSliverListView<T>> {
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
    if (widget.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
    widget.controller?.attachAppend(_appendIndicatorKey);

    _nextPage = widget.initialPage;
    _nextMaxId = widget.initialMaxId;
  }

  Future<void> _getData({@required bool reset}) async {
    // reset page
    if (reset) {
      _nextPage = widget.initialPage;
      _nextMaxId = widget.initialMaxId;
    }

    // start loading
    _loading = true;
    _forceState = null;
    if (reset && widget.clearWhenRefreshing) {
      _errorMessage = '';
      widget.data.clear();
    }
    widget.onStartLoading?.call();
    if (mounted) setState(() {});

    // get data
    switch (widget.strategy) {
      case PaginationStrategy.offsetBased:
        //////////////////////////////////
        // offsetBased, use _nextPage
        //////////////////////////////////
        final func = widget.getDataByOffset(page: _nextPage);

        // return future
        return func.then((List<T> list) async {
          // success to get data without error
          _errorMessage = '';
          // check list size for update
          if (widget.updateOnlyIfNotEmpty && list.isEmpty) {
            return;
          }

          // replace or append
          if (reset) {
            widget.data.clear();
            if (mounted) setState(() {});
            await Future.delayed(Duration(milliseconds: 20));
            widget.data.addAll(list);
          } else {
            widget.data.addAll(list);
            widget.scrollController?.scrollDown();
          }
          _nextPage++;
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

      case PaginationStrategy.seekBased:
        ////////////////////////////////
        // seekBased, use _nextMaxId
        ////////////////////////////////
        if (_nextMaxId == widget.nothingMaxId) {
          await Future.delayed(Duration(milliseconds: 100));
          return Future.value();
        }
        final func = widget.getDataBySeek(maxId: _nextMaxId);

        // return future
        return func.then((SeekList<T> data) async {
          // success to get data without error
          _errorMessage = '';
          // check list size for update
          if (widget.updateOnlyIfNotEmpty && data.list.isEmpty) {
            return;
          }

          // replace or append
          if (reset) {
            if (widget.data.isNotEmpty) {
              widget.data.clear();
              if (mounted) setState(() {});
              await Future.delayed(Duration(milliseconds: 20));
            }
            widget.data.addAll(data.list);
          } else {
            widget.data.addAll(data.list);
            widget.scrollController?.scrollDown();
          }
          _nextMaxId = data.nextMaxId;
          widget.onAppend?.call(data.list);
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
        child: PlaceholderText.from(
          onRefresh: _refreshIndicatorKey.currentState?.show,
          forceState: _forceState,
          isLoading: _loading,
          isEmpty: widget.data.isEmpty,
          errorText: _errorMessage,
          onChanged: widget.onStateChanged,
          setting: widget.placeholderSetting,
          childBuilder: (c) => Scrollbar(
            child: CustomScrollView(
              controller: widget.scrollController,
              shrinkWrap: widget.shrinkWrap ?? false,
              physics: widget.physics,
              reverse: widget.reverse ?? false,
              slivers: [
                if (widget.hasOverlapAbsorber)
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                if (widget.topSliver != null) widget.topSliver,
                SliverPadding(
                  padding: widget.padding,
                  sliver: SliverList(
                    delegate: widget.separator == null
                        ? SliverChildBuilderDelegate(
                            (c, idx) => widget.itemBuilder(c, widget.data[idx]),
                            childCount: widget.data.length,
                          )
                        : SliverChildBuilderDelegate(
                            (c, idx) => idx % 2 == 0
                                ? widget.itemBuilder(
                                    c,
                                    widget.data[idx ~/ 2],
                                  )
                                : widget.separator,
                            childCount: widget.data.length * 2 - 1,
                          ),
                  ),
                ),
                if (widget.bottomSliver != null) widget.bottomSliver,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
