import 'package:flutter/material.dart';

/// Represent an action used in [ActionController].
typedef Action<T> = T Function();

/// Controller for invoking some actions stored in a callback list.
class ActionController {
  Map<dynamic, Action> _actions = {};

  /// Add an action to the callback list.
  void addAction<T>(dynamic key, Action<T> action) {
    _actions[key] = action;
  }

  /// Remove an action from the callback list.
  void removeAction<T>(dynamic key) {
    _actions.remove(key);
  }

  /// Get the action by the given [key] in the callback list, return null if not found.
  Action<T> getAction<T>(dynamic key) {
    return _actions[key];
  }

  /// Returns true if this controller contains the given [key].
  bool containAction(dynamic key) {
    return _actions.containsKey(key);
  }

  /// Invoke the action by the given [key] in the callback list, return null if not found.
  T invoke<T>(dynamic key) {
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
