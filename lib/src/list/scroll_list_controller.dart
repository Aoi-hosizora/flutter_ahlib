import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';

/// [ScrollListController] is a controller used for controlling of the
/// [RefreshIndicator] and [AppendIndicator], including [refresh] and [append].
class ScrollListController {
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
