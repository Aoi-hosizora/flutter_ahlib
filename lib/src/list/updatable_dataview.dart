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

/// A list of extra widgets for [UpdatableDataView], includes widget lies before or after [ScrollView], inside or outside [PlaceholderText].
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
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }

  /// Shows the append indicator and runs the callback as if it had been started interactively.
  Future<void> append() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }
}
