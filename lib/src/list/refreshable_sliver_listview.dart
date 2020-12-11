import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/updatable_list_func.dart';
import 'package:flutter_ahlib/src/list/updatable_list_controller.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';
import 'package:flutter_ahlib/src/widget/sliver_separated_delegate.dart';

/// Refreshable [SliverList] is a kind of updatable list, with
/// [PlaceholderText], [RefreshIndicator], [Scrollbar] and [SliverList].
class RefreshableSliverListView<T> extends StatefulWidget {
  const RefreshableSliverListView({
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
    this.hasOverlapAbsorber = false,
    this.separator,
    // parameter for extra columns
    this.innerTopSliver,
    this.innerBottomSliver,
    // end of parameter
  })  : assert(data != null && getData != null),
        assert(setting != null),
        assert(itemBuilder != null),
        assert(hasOverlapAbsorber != null),
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

  /// The controller for inner [CustomScrollView].
  final ScrollController scrollController;

  /// The itemBuilder for [SliverList].
  final Widget Function(BuildContext, T) itemBuilder;

  /// The padding for [SliverList].
  final EdgeInsetsGeometry padding;

  /// The physics for [CustomScrollView].
  final ScrollPhysics physics;

  /// The reverse for [CustomScrollView].
  final bool reverse;

  /// The shrinkWrap for [CustomScrollView].
  final bool shrinkWrap;

  /// Check if outer [NestedScrollView] use [SliverOverlapAbsorber].
  final bool hasOverlapAbsorber;

  /// The separator between items in [ListView].
  final Widget separator;

  // parameter for extra columns

  /// The widget before [SliverList] in [PlaceholderText].
  final Widget innerTopSliver;

  /// The widget after [SliverList] in [PlaceholderText].
  final Widget innerBottomSliver;

  @override
  _RefreshableSliverListViewState<T> createState() => _RefreshableSliverListViewState<T>();
}

class _RefreshableSliverListViewState<T> extends State<RefreshableSliverListView<T>> with AutomaticKeepAliveClientMixin<RefreshableSliverListView<T>> {
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
      child: PlaceholderText.from(
        onRefresh: _refreshIndicatorKey.currentState?.show,
        forceState: _forceState,
        isLoading: _loading,
        isEmpty: widget.data.isEmpty,
        errorText: _errorMessage,
        onChanged: widget.setting.onStateChanged,
        setting: widget.setting.placeholderSetting,
        childBuilder: (c) => Scrollbar(
          child: CustomScrollView(
            // ===================================
            controller: widget.scrollController,
            // ===================================
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
            // ===================================
          ),
        ),
      ),
    );
  }
}
