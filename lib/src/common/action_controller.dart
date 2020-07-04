import 'package:flutter/material.dart';

typedef Action<T> = T Function();

/// Controller for some action, include a `map<String, Action>` to save callbacks.
class ActionController {
  Map<String, Action> _actions = {};

  void addAction<T>(String key, Action<T> action) {
    _actions[key] = action;
  }

  void removeAction<T>(String key, Action<T> action) {
    _actions.remove(key);
  }

  Action<T> getAction<T>(String key) {
    return _actions[key];
  }

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
