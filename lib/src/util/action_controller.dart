import 'package:flutter/material.dart';

/// Represent an action used in [ActionController].
typedef Action<T> = T Function();

/// Controller for invoking some actions stored in a callback list.
class ActionController {
  Map<dynamic, Action> _actions = {};

  /// Add an action.
  void addAction<T>(dynamic key, Action<T> action) {
    _actions[key] = action;
  }

  /// Remove an action.
  void removeAction<T>(dynamic key) {
    _actions.remove(key);
  }

  /// Check if contains the given [key].
  bool containsAction(dynamic key) {
    return _actions.containsKey(key);
  }

  /// Get the action by the given [key], return null if not found.
  Action<T> getAction<T>(dynamic key) {
    return _actions[key];
  }

  /// Invoke an action by the given [key], return null if not found.
  T invoke<T>(dynamic key) {
    var r = _actions[key]?.call();
    if (r != null) {
      return r as T;
    }
    return null;
  }

  /// Invoke some actions by the given [where] condition, and return the list of returned results.
  List<dynamic> invokeWhere(bool Function(dynamic) where) {
    assert(where != null);
    var keys = _actions.keys.where((k) => where(k));
    var rs = <dynamic>[];
    for (var key in keys) {
      rs.add(invoke<dynamic>(key));
    }
    return rs;
  }

  @mustCallSuper
  void dispose() {
    _actions = null;
  }
}
