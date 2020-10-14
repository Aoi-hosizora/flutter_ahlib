import 'package:flutter/material.dart';

/// Represent an action used in [ActionController].
typedef Action<T> = T Function();

/// Controller for invoking some actions stored in a callback list.
class ActionController {
  Map<String, Action> _actions = {};

  /// Add an action to the callback list.
  void addAction<T>(String key, Action<T> action) {
    _actions[key] = action;
  }

  /// Remove an action from the callback list.
  void removeAction<T>(String key, Action<T> action) {
    _actions.remove(key);
  }

  /// Get the action by the given [key] in the callback list, return null if not found.
  Action<T> getAction<T>(String key) {
    return _actions[key];
  }

  /// Invoke the action by the given [key] in the callback list, return null if not found.
  T invoke<T>(String key) {
    var r = _actions[key]?.call();
    if (r != null) {
      return r as T;
    }
    return null;
  }

  @mustCallSuper
  void dispose() {
    _actions = null;
  }
}
