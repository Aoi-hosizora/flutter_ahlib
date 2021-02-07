import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// An abstract widget for updatable data view, implements by [RefreshableDataView] and [PaginationDataView].
abstract class UpdatableDataView<T> extends StatefulWidget {
  const UpdatableDataView({Key key}) : super(key: key);

  /// The list of data.
  List<T> get data;

  /// The display and behavior setting.
  UpdatableDataViewSetting<T> get setting;

  /// The controller for the behavior.
  UpdatableDataViewController get controller;

  /// The controller for [ScrollView].
  ScrollController get scrollController;

  /// The itemBuilder for [ScrollView].
  Widget Function(BuildContext, T) get itemBuilder;
}

/// A list of behavior and display settings for [UpdatableDataView].
class UpdatableDataViewSetting<T> {
  const UpdatableDataViewSetting({
    // display
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.reverse = false,
    this.shrinkWrap = false,
    this.showScrollbar = true,
    this.scrollbarThickness,
    this.scrollbarRadius,
    this.placeholderSetting = const PlaceholderSetting(),
    this.onStateChanged,
    this.wantKeepAlive = true,
    // behavior
    this.refreshFirst = true,
    this.clearWhenRefresh = false,
    this.clearWhenError = false,
    this.updateOnlyIfNotEmpty = false,
    this.onStartLoading,
    this.onStopLoading,
    this.onStartRefreshing,
    this.onStopRefreshing,
    this.onAppend,
    this.onError,
    this.onNothing,
  })  : assert(reverse != null),
        assert(shrinkWrap != null),
        assert(showScrollbar != null),
        assert(placeholderSetting != null),
        assert(wantKeepAlive != null),
        assert(refreshFirst != null),
        assert(clearWhenRefresh != null),
        assert(clearWhenError != null),
        assert(updateOnlyIfNotEmpty != null);

  // Display settings

  /// The padding for [ScrollView].
  final EdgeInsetsGeometry padding;

  /// The physics for [ScrollView].
  final ScrollPhysics physics;

  /// The reverse for [ScrollView].
  final bool reverse;

  /// The shrinkWrap for [ScrollView].
  final bool shrinkWrap;

  /// The visibility for [Scrollbar].
  final bool showScrollbar;

  /// The thickness for [Scrollbar].
  final double scrollbarThickness;

  /// The radius for [Scrollbar].
  final Radius scrollbarRadius;

  /// The setting for [PlaceholderText].
  final PlaceholderSetting placeholderSetting;

  /// The callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback onStateChanged;

  /// The wantKeepAlive for [AutomaticKeepAliveClientMixin].
  final bool wantKeepAlive;

  // Behavior settings

  /// The switcher to do refresh when init view.
  final bool refreshFirst;

  /// The switcher to clear list and error message when refresh data.
  final bool clearWhenRefresh;

  /// The switcher to clear list when error aroused.
  final bool clearWhenError;

  /// The switcher to update list only when the returned data is not empty, used for pagination.
  final bool updateOnlyIfNotEmpty;

  /// The callback when start loading.
  final void Function() onStartLoading;

  /// The callback when stop loading.
  final void Function() onStopLoading;

  /// The callback when start refreshing.
  final void Function() onStartRefreshing;

  /// The callback when stop refreshing.
  final void Function() onStopRefreshing;

  /// The callback when data has been appended.
  final void Function(List<T>) onAppend;

  /// The callback when error invoked.
  final void Function(dynamic) onError;

  /// The callback when get nothing, used for pagination.
  final void Function() onNothing;
}

/// A list of extra widgets used in [UpdatableDataView], includes widget and divider lies before or after [ScrollView], inside or outside [PlaceholderText].
///
/// Widgets order:
/// ```
/// outerTopWidget
/// outerTopDivider
/// innerTopWidget
/// innerTopDivider
/// ==========
/// inListTopWidgets
/// ...
/// inListBottomWidgets
/// ==========
/// innerBottomDivider
/// innerBottomWidget
/// outerBottomDivider
/// outerBottomWidget
/// ```
class UpdatableDataViewExtraWidgets {
  const UpdatableDataViewExtraWidgets({
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.outerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outerTopWidget,
    this.outerBottomWidget,
    this.inListTopWidgets,
    this.inListBottomWidgets,
    this.innerTopDivider,
    this.innerBottomDivider,
    this.outerTopDivider,
    this.outerBottomDivider,
  });

  /// The crossAxisAlignment for inner [Column] inside [PlaceholderText].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The crossAxisAlignment for outer [Column] outside [PlaceholderText].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [ScrollView] inside [PlaceholderText].
  final Widget innerTopWidget;

  /// The widget after [ScrollView] inside [PlaceholderText].
  final Widget innerBottomWidget;

  /// The widget before [ScrollView] outside [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [ScrollView] outside [PlaceholderText].
  final Widget outerBottomWidget;

  /// The widgets in the top of [ScrollView], that will have no separator between items.
  final List<Widget> inListTopWidgets;

  /// The widgets in the bottom of [ScrollView], that will have no separator between items.
  final List<Widget> inListBottomWidgets;

  // /// The widgets in the bottom of the top of [ScrollView], that will have separator between items.
  // final List<Widget> inListBottomOfTopWidgets;
  //
  // /// The widgets in the top of the bottom of [ScrollView], that will have separator between items.
  // final List<Widget> inListTopOfBottomWidgets;

  /// The divider before [ScrollView] inside [PlaceholderText], if null, do not show it.
  final Widget innerTopDivider;

  /// The divider after [ScrollView] inside [PlaceholderText], if null, do not show it.
  final Widget innerBottomDivider;

  /// The divider before [ScrollView] outside [PlaceholderText], if null, do not show it.
  final Widget outerTopDivider;

  /// The divider after [ScrollView] outside [PlaceholderText], if null, do not show it.
  final Widget outerBottomDivider;
}

/// A controller for [UpdatableDataView], uses two [GlobalKey]-s to control [RefreshIndicator] and [AppendIndicator], and includes [refresh] and [append] methods.
class UpdatableDataViewController {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;

  /// Registers the given [GlobalKey] of [RefreshIndicatorState] to this controller.
  void attachRefresh(GlobalKey<RefreshIndicatorState> key) => _refreshIndicatorKey = key;

  /// Registers the given [GlobalKey] of [AppendIndicatorState] to this controller.
  void attachAppend(GlobalKey<AppendIndicatorState> key) => _appendIndicatorKey = key;

  /// Unregisters the given [GlobalKey] of [RefreshIndicatorState] from this controller.
  void detachRefresh() => _refreshIndicatorKey = null;

  /// Unregisters the given [GlobalKey] of [AppendIndicatorState] from this controller.
  void detachAppend() => _appendIndicatorKey = null;

  @mustCallSuper
  void dispose() {
    detachRefresh();
    detachAppend();
  }

  /// Shows the refresh indicator and runs the callback as if it had been started interactively.
  Future<void> refresh() {
    return _refreshIndicatorKey?.currentState?.show() ?? Future.value();
  }

  /// Shows the append indicator and runs the callback as if it had been started interactively.
  Future<void> append() {
    return _appendIndicatorKey?.currentState?.show() ?? Future.value();
  }
}
