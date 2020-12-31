import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_dataview.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_delegate.dart';

/// Refreshable [SliverList] is an implementation of [RefreshableDataView], with
/// [PlaceholderText], [RefreshIndicator], [Scrollbar] and [SliverList].
class RefreshableSliverListView<T> extends RefreshableDataView<T> {
  const RefreshableSliverListView({
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
    this.hasOverlapAbsorber = false,
    this.separator,
    this.innerTopSliver,
    this.innerBottomSliver,
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
        super(key: key);

  /// The list of scored data, need to be created out of widget.
  @override
  final List<T> data;

  /// Function to get list data.
  @override
  final Future<List<T>> Function() getData;

  /// Some behavior and display settings.
  @override
  final UpdatableDataViewSetting setting;

  /// The controller of the behavior.
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

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber].
  final bool hasOverlapAbsorber;

  /// The separator between items in [SliverList].
  final Widget separator;

  /// The widget before [SliverList] in [PlaceholderText].
  final Widget innerTopSliver;

  /// The widget after [SliverList] in [PlaceholderText].
  final Widget innerBottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
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

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => _getData(),
      child: PlaceholderText.from(
        onRefresh: _refreshIndicatorKey.currentState?.show,
        forceState: _forceState,
        isLoading: _loading,
        isEmpty: widget.data.isEmpty,
        errorText: _errorMessage,
        onChanged: widget.setting.onStateChanged,
        setting: widget.setting.placeholderSetting,
        childBuilder: (c) => widget.setting.showScrollbar
            ? Scrollbar(
                thickness: widget.setting.scrollbarThickness,
                radius: widget.setting.scrollbarRadius,
                child: view,
              )
            : view,
      ),
    );
  }
}
