import 'package:flutter/material.dart';

/// An action function used in [ActionController].
typedef Action<T> = T Function();

/// A controller used to invoke some actions stored in a callback list.
class ActionController {
  Map<dynamic, Action> _actions = {}; // callback list

  /// Adds an action.
  void addAction<T>(dynamic key, Action<T> action) {
    _actions[key] = action;
  }

  /// Removes an action.
  void removeAction<T>(dynamic key) {
    _actions.remove(key);
  }

  /// Checks if contains the given [key].
  bool containsAction(dynamic key) {
    return _actions.containsKey(key);
  }

  /// Gets the action by the given [key], returns null if not found.
  Action<T> getAction<T>(dynamic key) {
    return _actions[key];
  }

  /// Invokes an action by the given [key], returns null if not found.
  T invoke<T>(dynamic key) {
    var r = _actions[key]?.call();
    if (r != null) {
      return r as T;
    }
    return null;
  }

  /// Invokes some actions by the given [where] key condition, and returns the list of returned results.
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
