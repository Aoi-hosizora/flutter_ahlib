import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/list/pagination_type.dart';
import 'package:flutter_ahlib/src/list/scroll_more_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Appendable [ListView] with [AppendIndicator], [RefreshIndicator], [PlaceholderText], [Scrollbar].
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
    this.refreshFirst = true,
    this.updateOnlyIfNotEmpty = false,
    this.onStateChanged,
    this.placeholderSetting,
    this.controller,
    @required this.itemBuilder,
    this.padding,
    this.shrinkWrap,
    this.physics,
    this.reverse,
    this.primary,
    this.separator,
    this.topWidget,
    this.bottomWidget,
  })  : assert(data != null),
        assert((strategy == PaginationStrategy.offsetBased && getDataByOffset != null && initialPage != null) ||
            (strategy == PaginationStrategy.seekBased && getDataBySeek != null && initialMaxId != nothingMaxId)),
        assert(refreshFirst != null),
        assert(updateOnlyIfNotEmpty != null),
        assert(itemBuilder != null),
        super(key: key);

  /// List data, need to create this list outside [PaginationListView].
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

  /// Do refresh when init view.
  final bool refreshFirst;

  /// If return data is empty, then do nothing, else update list and parameter.
  final bool updateOnlyIfNotEmpty;

  /// Callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// [ListView] controller, with more helper functions.
  final ScrollMoreController controller;

  /// The itemBuilder for [ListView].
  final Widget Function(BuildContext, T) itemBuilder;

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

  /// The separator between items in [ListView].
  final Widget separator;

  /// The widget before [ListView].
  final Widget topWidget;

  /// The widget after [ListView].
  final Widget bottomWidget;

  @override
  _PaginationListViewState<T> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> with AutomaticKeepAliveClientMixin<PaginationListView<T>> {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

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
  }

  _PaginationListViewState() {
    _nextPage = widget.initialPage;
    _nextMaxId = widget.initialMaxId;
  }

  int _nextPage; // offsetBased
  dynamic _nextMaxId; // seekBased
  bool _loading = true;
  String _errorMessage;

  Future<void> _getData({@required bool reset}) async {
    // check reset page
    if (reset) {
      _nextPage = widget.initialPage;
      _nextMaxId = widget.initialMaxId;
    }

    // start loading
    _loading = true;
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
          // success to get data with no error
          _errorMessage = null;

          // check update or no nothing
          if (widget.updateOnlyIfNotEmpty && list.isEmpty) {
            return; // strange error, maybe server internal error
          }

          // update nextPage
          _nextPage++;

          // replace or append
          if (reset) {
            widget.data.clear();
            if (mounted) setState(() {});
            await Future.delayed(Duration(milliseconds: 20)); // must delayed
            widget.data.addAll(list); // replace to the new list
          } else {
            widget.data.addAll(list); // append directly
            widget.controller?.scrollDown();
          }
        }).catchError((e) {
          // error aroused, record the message
          _errorMessage = e.toString();
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
          // success to get data with no error
          _errorMessage = null;

          // check update or no nothing
          if (widget.updateOnlyIfNotEmpty && data.list.isEmpty) {
            return; // strange error, maybe server internal error
          }

          // update nextMaxId
          _nextMaxId = data.nextMaxId;

          // replace or append
          if (reset) {
            widget.data.clear();
            if (mounted) setState(() {});
            await Future.delayed(Duration(milliseconds: 20)); // must delayed
            widget.data.addAll(data.list); // replace to the new list
          } else {
            widget.data.addAll(data.list); // append directly
            widget.controller?.scrollDown();
          }
        }).catchError((e) {
          // error aroused, record the message
          _errorMessage = e.toString();
        }).whenComplete(() {
          // finish loading and setState
          _loading = false;
          if (mounted) setState(() {});
        });
    }
  }

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
                  child: ListView.separated(
                    controller: widget.controller,
                    shrinkWrap: widget.shrinkWrap ?? false,
                    physics: widget.physics,
                    reverse: widget.reverse ?? false,
                    padding: widget.padding,
                    itemCount: widget.data.length,
                    separatorBuilder: (c, idx) => widget.separator ?? SizedBox(height: 0),
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
