import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// Refreshable [ListView] is an implementation of [RefreshableDataView], with
/// [PlaceholderText], [RefreshIndicator], [Scrollbar] and [ListView].
class RefreshableListView<T> extends RefreshableDataView<T> {
  const RefreshableListView({
    Key key,
    @required this.data,
    @required this.getData,
    this.setting = const UpdatableDataViewSetting(),
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
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(separator == null),
        super(key: key);

  /// The list of scored data, need to be created out of widget.
  @override
  final List<T> data;

  /// Function to get list data.
  @override
  final Future<List<T>> Function() getData;

  /// Some behavior and display settings.
  @override
  final UpdatableDataViewSetting<T> setting;

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
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin<RefreshableListView<T>> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PlaceholderState _forceState;
  var _loading = false;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.setting.refreshFirst) {
      _forceState = PlaceholderState.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey?.currentState?.show());
    }
    widget.controller?.attachRefresh(_refreshIndicatorKey);
  }

  @override
  void dispose() {
    widget.controller?.detachRefresh();
    super.dispose();
  }

  Future<void> _getData() async {
    _forceState = null;
    widget.setting.onRefresh?.call();
    return widget.getDataCore(
      setLoading: (l) => _loading = l,
      setErrorMessage: (e) => _errorMessage = e,
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
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
                    child: widget.setting.showScrollbar
                        ? Scrollbar(
                            thickness: widget.setting.scrollbarThickness,
                            radius: widget.setting.scrollbarRadius,
                            child: view,
                          )
                        : view,
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
