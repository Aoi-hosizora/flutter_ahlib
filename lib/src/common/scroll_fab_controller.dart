import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/common/action_controller.dart';

/// A auto controller for `ScrollFloatingActionButton`, include show fab and hide fav function
class ScrollFabController {
  AnimationController _animeController;
  ActionController _actionController;

  void attach(AnimationController c) => _animeController = c;
  void detach() => _animeController = null;

  void attachAction(ActionController c) => _actionController = c;
  void detachAction() => _actionController = null;

  void addListener() {
    _actionController?.invoke('addListener');
  }

  void removeListener() {
    _actionController?.invoke('removeListener');
  }

  void show() {
    _animeController?.forward();
  }

  void hide() {
    _animeController?.reverse();
  }

  @mustCallSuper
  void dispose() {
    _animeController = null;
  }
}
