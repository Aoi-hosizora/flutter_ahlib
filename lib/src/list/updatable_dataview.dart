import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// An abstract widget for updatable data view, implements by [RefreshableDataView] and [PaginationDataView].
abstract class UpdatableDataView<T> extends StatefulWidget {
  const UpdatableDataView({Key? key}) : super(key: key);

  /// The list of data.
  List<T> get data;

  /// The display and behavior setting.
  UpdatableDataViewSetting<T> get setting;

  /// The controller for the behavior.
  UpdatableDataViewController? get controller;

  /// The controller for [ScrollView].
  ScrollController? get scrollController;

  /// The itemBuilder for [ScrollView].
  Widget Function(BuildContext, T) get itemBuilder;

  /// The separator for [ScrollView].
  Widget? get separator;

  /// The extra widgets around [ScrollView].
  UpdatableDataViewExtraWidgets? get extra;
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
    this.alwaysShowScrollbar = false,
    this.scrollbarInteractive = false,
    this.scrollbarRadius,
    this.scrollbarThickness,
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
  });

  // Display settings

  /// The padding for [ScrollView].
  final EdgeInsetsGeometry? padding;

  /// The physics for [ScrollView], defaults to AlwaysScrollableScrollPhysics().
  final ScrollPhysics? physics;

  /// The reverse for [ScrollView], defaults to false.
  final bool? reverse;

  /// The shrinkWrap for [ScrollView], defaults to false.
  final bool? shrinkWrap;

  /// The visibility for [Scrollbar], defaults to true.
  final bool? showScrollbar;

  /// The check to always show [Scrollbar], defaults to false.
  final bool? alwaysShowScrollbar;

  /// The interactive for [Scrollbar], defaults to false, you must pass non-null [ScrollController] if you set this to true.
  final bool? scrollbarInteractive;

  /// The radius for [Scrollbar].
  final Radius? scrollbarRadius;

  /// The thickness for [Scrollbar].
  final double? scrollbarThickness;

  /// The setting for [PlaceholderText], defaults to PlaceholderSetting().
  final PlaceholderSetting? placeholderSetting;

  /// The callback when [PlaceholderText] state changed.
  final PlaceholderStateChangedCallback? onStateChanged;

  /// The wantKeepAlive for [AutomaticKeepAliveClientMixin], defaults to true.
  final bool? wantKeepAlive;

  // Behavior settings

  /// The switcher to do refresh when init view, defaults to true.
  final bool? refreshFirst;

  /// The switcher to clear list and error message when refresh data, defaults to false.
  final bool? clearWhenRefresh;

  /// The switcher to clear list when error aroused, defaults to false.
  final bool? clearWhenError;

  /// The switcher to update list only when the returned data is not empty, defaults to false, used for pagination.
  final bool? updateOnlyIfNotEmpty;

  /// The callback when start loading.
  final void Function()? onStartLoading;

  /// The callback when stop loading.
  final void Function()? onStopLoading;

  /// The callback when start refreshing.
  final void Function()? onStartRefreshing;

  /// The callback when stop refreshing.
  final void Function()? onStopRefreshing;

  /// The callback when data has been appended.
  final void Function(List<T>)? onAppend;

  /// The callback when error invoked.
  final void Function(dynamic)? onError;

  /// The callback when get nothing, used for pagination.
  final void Function()? onNothing;
}

/// A list of extra widgets used in [UpdatableDataView], includes widget and divider lies before or after [ScrollView], inside or outside [PlaceholderText].
///
/// Widgets order:
/// ```
/// outerTopWidgets
/// ================== (PlaceholderText)
/// innerTopWidgets
/// ================== (ScrollView)
/// listTopWidgets
/// ...                (with separator)
/// listBottomWidgets
/// ================== (ScrollView)
/// innerBottomWidgets
/// ================== (PlaceholderText)
/// outerBottomWidgets
/// ```
class UpdatableDataViewExtraWidgets {
  const UpdatableDataViewExtraWidgets({
    this.outerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.outerTopWidgets,
    this.innerTopWidgets,
    this.listTopWidgets,
    this.listBottomWidgets,
    this.innerBottomWidgets,
    this.outerBottomWidgets,
  });

  /// The crossAxisAlignment for outer [Column] outside [PlaceholderText], defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment? outerCrossAxisAlignment;

  /// The crossAxisAlignment for inner [Column] inside [PlaceholderText], defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment? innerCrossAxisAlignment;

  /// The widget before [ScrollView] and outside [PlaceholderText].
  final List<Widget>? outerTopWidgets;

  /// The widget before [ScrollView] and inside [PlaceholderText].
  final List<Widget>? innerTopWidgets;

  /// The widgets in the top of [ScrollView], and there is no separator between widgets.
  final List<Widget>? listTopWidgets;

  /// The widgets in the bottom of [ScrollView], and there is no separator between widgets.
  final List<Widget>? listBottomWidgets;

  /// The widget after [ScrollView] and inside [PlaceholderText].
  final List<Widget>? innerBottomWidgets;

  /// The widget after [ScrollView] and outside [PlaceholderText].
  final List<Widget>? outerBottomWidgets;
}

/// A controller for [UpdatableDataView], uses two [GlobalKey]-s to control [RefreshIndicator] and [AppendIndicator], and includes [refresh] and [append] methods.
class UpdatableDataViewController {
  GlobalKey<RefreshIndicatorState>? _refreshIndicatorKey;
  GlobalKey<AppendIndicatorState>? _appendIndicatorKey;

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
