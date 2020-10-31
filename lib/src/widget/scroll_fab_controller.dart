import 'package:flutter/material.dart';
import 'file:///F:/Projects/flutter_ahlib/lib/src/common/action_controller.dart';

/// Controller for [ScrollFloatingActionButton], includes show and hide function
class ScrollFabController {
  AnimationController _animeController;
  ActionController _actionController;

  /// Register the given [AnimationController] with this controller.
  void attach(AnimationController c) => _animeController = c;

  /// Unregister the given [AnimationController] with this controller.
  void detach() => _animeController = null;

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

  /// Show the fab with [_animeController].
  void show() {
    _animeController?.forward();
  }

  /// Hide the fab with [_animeController].
  void hide() {
    _animeController?.reverse();
  }

  @mustCallSuper
  void dispose() {
    _animeController = null;
    _actionController = null;
  }
}
