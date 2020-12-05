import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/pagination_type.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Pagination [ListView] with [PlaceholderText], [AppendIndicator], [RefreshIndicator], [Scrollbar].
class PaginationListView<T> extends StatefulWidget {
  const PaginationListView({
    Key key,
    @required this.data,
    @required this.strategy,
    this.getDataByOffset,
    this.initialPage,
    this.getDataBySeek,
    this.initialMaxId,
    this.nothingMaxId,
    this.onAppend,
    this.onError,
    this.clearWhenRefreshing = false,
    this.clearWhenError = false,
    this.updateOnlyIfNotEmpty = false,
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
  })  : assert(data != null),
        assert(strategy != PaginationStrategy.offsetBased || getDataByOffset != null),
        assert(strategy != PaginationStrategy.seekBased || getDataBySeek != null),
        assert(clearWhenRefreshing != null),
        assert(clearWhenError != null),
        assert(updateOnlyIfNotEmpty != null),
        assert(refreshFirst != null),
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

  /// The physics for [ListView].
  final ScrollPhysics physics;

  /// The reverse for [ListView].
  final bool reverse;

  /// The primary for [ListView].
  final bool primary;

  /// The mainAxisAlignment for [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The mainAxisSize for [Column].
  final MainAxisSize mainAxisSize;

  /// The crossAxisAlignment for [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The widget before [ListView].
  final Widget topWidget;

  /// The widget after [ListView].
  final Widget bottomWidget;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachAppend(_appendIndicatorKey);
    widget.controller?.attachRefresh(_refreshIndicatorKey);

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
    if (reset && widget.clearWhenRefreshing) {
      _errorMessage = '';
      widget.data.clear();
    }
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
            widget.controller?.scrollDown();
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
            widget.data.clear();
            if (mounted) setState(() {});
            await Future.delayed(Duration(milliseconds: 20));
            widget.data.addAll(data.list);
          } else {
            widget.data.addAll(data.list);
            widget.controller?.scrollDown();
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
          if (mounted) setState(() {});
        });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(reset: true),
      child: AppendIndicator(
        key: _appendIndicatorKey,
        onAppend: () => _getData(reset: false),
        child: PlaceholderText.from(
          onRefresh: _refreshIndicatorKey.currentState?.show,
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
    );
  }
}
