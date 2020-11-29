import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/common/action_controller.dart';
import 'package:flutter_ahlib/src/widget/scroll_fab.dart';

/// Controller for [ScrollFloatingActionButton], includes show and hide function
class ScrollFabController {
  AnimationController _animController;
  ActionController _actionController;

  /// Register the given [AnimationController] with this controller.
  void attachAnim(AnimationController c) => _animController = c;

  /// Unregister the given [AnimationController] with this controller.
  void detachAnim() => _animController = null;

  /// Register the given [ActionController] with this controller.
  void attachAction(ActionController c) => _actionController = c;

  /// Unregister the given [ActionController] with this controller.
  void detachAction() => _actionController = null;

  /// Invoke add listener by [_actionController].
  void addListener() {
    _actionController?.invoke('addListener');
  }

  /// Invoke remove listener by [_actionController].
  void removeListener() {
    _actionController?.invoke('removeListener');
  }

  /// Show the fab with [_animController].
  void show() {
    _animController?.forward();
  }

  /// Hide the fab with [_animController].
  void hide() {
    _animController?.reverse();
  }

  @mustCallSuper
  void dispose() {
    _animController = null;
    _actionController = null;
  }
}
