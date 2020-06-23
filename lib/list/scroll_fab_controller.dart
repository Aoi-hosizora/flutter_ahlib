import 'package:flutter/material.dart';

class ScrollFabController {
  AnimationController _animeController;

  void attach(AnimationController c) => _animeController = c;
  void detach() => _animeController = null;

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
