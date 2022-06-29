import 'package:flutter/material.dart';

/// An action function used in [ActionController].
typedef Action<T> = T Function();

/// A controller which is used to store and invoke action callbacks. This controller can be used to implement
/// point-to-point communication across widgets. If you want to use publish/subscribe pattern, or said event bus,
/// please use https://pub.dev/packages/event_bus.
///
/// Example:
/// ```
/// class WidgetA extends StatelessWidget {
///   WidgetA({Key? key}) : super(key: key);
///   final _action = ActionController()..addAction('key', () { /* do something */ }); // add action
///
///   @override
///   Widget build(BuildContext context) => WidgetB(action: _action);
/// }
///
/// class WidgetB extends StatelessWidget {
///   const WidgetB({Key? key, required this.action}) : super(key: key);
///   final ActionController action;
///
///   @override
///   Widget build(BuildContext context) => MaterialButton(onPressed: () => action.invoke('key')); // invoke action
/// }
/// ```
class ActionController {
  final _actions = <dynamic, Action>{}; // action list

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
  Action<T>? getAction<T>(dynamic key) {
    var action = _actions[key];
    if (action != null) {
      return action as Action<T>;
    }
    return null;
  }

  /// Invokes an action by the given [key], returns null if not found.
  T? invoke<T>(dynamic key) {
    var r = _actions[key]?.call();
    if (r != null) {
      return r as T;
    }
    return null;
  }

  /// Invokes some actions by the given [where] key condition, and returns the list of returned results.
  List<dynamic> invokeWhere(bool Function(dynamic) where) {
    var keys = _actions.keys.where((k) => where(k));
    var rs = <dynamic>[];
    for (var key in keys) {
      rs.add(invoke<dynamic>(key));
    }
    return rs;
  }

  @mustCallSuper
  void dispose() {
    _actions.clear();
  }
}
