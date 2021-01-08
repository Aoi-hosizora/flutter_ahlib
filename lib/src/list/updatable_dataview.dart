import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter_ahlib/src/widget/placeholder_text.dart';

/// An abstract widget for updatable data view, including [RefreshableDataView] and [PaginationDataView].
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
    // ===================================
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

  /* Display setting */

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

  /* Behavior setting */

  /// Do refresh when init view.
  final bool refreshFirst;

  /// Clear list and error message when refresh data.
  final bool clearWhenRefresh;

  /// Clear list when error aroused.
  final bool clearWhenError;

  /// Update list only when return data is not empty, used for pagination.
  final bool updateOnlyIfNotEmpty;

  /// Callback when start loading.
  final void Function() onStartLoading;

  /// Callback when stop loading.
  final void Function() onStopLoading;

  /// Callback when start refreshing.
  final void Function() onStartRefreshing;

  /// Callback when stop refreshing.
  final void Function() onStopRefreshing;

  /// Callback when data has been appended.
  final void Function(List<T>) onAppend;

  /// Callback when error invoked.
  final void Function(dynamic) onError;

  /// Callback when get nothing, used for pagination.
  final void Function() onNothing;
}

/// Some extra widgets for [UpdatableDataView], these widgets are inside or outside [PlaceholderText],
/// and lies before or after [ScrollView].
class UpdatableDataViewExtraWidgets {
  const UpdatableDataViewExtraWidgets({
    this.innerCrossAxisAlignment = CrossAxisAlignment.center,
    this.outerCrossAxisAlignment = CrossAxisAlignment.center,
    this.innerTopWidget,
    this.innerBottomWidget,
    this.outerTopWidget,
    this.outerBottomWidget,
  });

  /// The crossAxisAlignment for inner [Column] inside [PlaceholderText].
  final CrossAxisAlignment innerCrossAxisAlignment;

  /// The crossAxisAlignment for outer [Column] outside [PlaceholderText].
  final CrossAxisAlignment outerCrossAxisAlignment;

  /// The widget before [ListView] inside [PlaceholderText].
  final Widget innerTopWidget;

  /// The widget after [ListView] inside [PlaceholderText].
  final Widget innerBottomWidget;

  /// The widget before [ListView] outside [PlaceholderText].
  final Widget outerTopWidget;

  /// The widget after [ListView] outside [PlaceholderText].
  final Widget outerBottomWidget;
}

/// A controller for [UpdatableDataView], it uses two [GlobalKey] to control
/// [RefreshIndicator] and [AppendIndicator], and includes [refresh] and [append].
class UpdatableDataViewController {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;

  /// Register the given [GlobalKey] of [RefreshIndicatorState] to this controller.
  void attachRefresh(GlobalKey<RefreshIndicatorState> key) => _refreshIndicatorKey = key;

  /// Register the given [GlobalKey] of [AppendIndicatorState] to this controller.
  void attachAppend(GlobalKey<AppendIndicatorState> key) => _appendIndicatorKey = key;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] from this controller.
  void detachRefresh() => _refreshIndicatorKey = null;

  /// Unregister the given [GlobalKey] of [AppendIndicatorState] from this controller.
  void detachAppend() => _appendIndicatorKey = null;

  @mustCallSuper
  void dispose() {
    detachRefresh();
    detachAppend();
  }

  /// Show the refresh indicator and run the callback as if it had been started interactively.
  /// See [RefreshIndicatorState.show].
  Future<void> refresh() {
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }

  /// Show the append indicator and run the callback as if it had been started interactively.
  /// See [AppendIndicatorState.show].
  Future<void> append() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }
}
