import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';

/// [ListController] is a controller used for controlling of the
/// [RefreshIndicator] and [AppendIndicator], including [append] and [refresh].
class ListController {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  /// Register the given [GlobalKey] of [AppendIndicatorState] to this controller.
  void attachAppend(GlobalKey<AppendIndicatorState> s) => _appendIndicatorKey = s;

  /// Register the given [GlobalKey] of [AppendIndicatorState] to this controller.
  void attachRefresh(GlobalKey<RefreshIndicatorState> r) => _refreshIndicatorKey = r;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] from this controller.
  void detachAppend() => _appendIndicatorKey = null;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] from this controller.
  void detachRefresh() => _refreshIndicatorKey = null;

  @mustCallSuper
  void dispose() {
    detachAppend();
    detachRefresh();
  }

  /// Show the append indicator and run the callback as if it had been started interactively.
  /// See [AppendIndicatorState.show].
  Future<void> append() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }

  /// Show the refresh indicator and run the callback as if it had been started interactively.
  /// See [RefreshIndicatorState.show].
  Future<void> refresh() {
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }
}
