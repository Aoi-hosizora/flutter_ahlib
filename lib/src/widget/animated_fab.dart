import 'package:flutter/material.dart';

/// A [FloatingActionButton] that will do animation with [show] parameter.
class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    Key key,
    @required this.fab,
    this.controller,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutBack,
    this.show = false,
  })  : assert(fab != null),
        assert(duration != null),
        assert(curve != null),
        assert(show != null),
        super(key: key);

  /// Child with [FloatingActionButton].
  final FloatingActionButton fab;

  /// Animated fab controller.
  final AnimatedFabController controller;

  /// The duration for [AnimationController].
  final Duration duration;

  /// The curve for [CurvedAnimation].
  final Curve curve;

  /// Show the fab or not.
  final bool show;

  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with TickerProviderStateMixin<AnimatedFab> {
  bool _lastShowFab;
  AnimationController _animController;
  Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: widget.duration);
    _fabAnimation = CurvedAnimation(parent: _animController, curve: widget.curve);
    widget.controller?.attachAnim(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastShowFab == null || widget.show != _lastShowFab) {
      _lastShowFab = widget.show;
      if (_lastShowFab) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }

    return ScaleTransition(
      scale: _fabAnimation,
      alignment: FractionalOffset.center,
      child: widget.fab,
    );
  }
}

/// A [FloatingActionButton] that will do animation when scrolling.
class ScrollAnimatedFab extends StatefulWidget {
  const ScrollAnimatedFab({
    Key key,
    @required this.fab,
    this.controller,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutBack,
    this.scrollController,
    this.offset = 50,
  })  : assert(fab != null),
        assert(duration != null),
        assert(curve != null),
        assert(offset != null && offset >= 0),
        super(key: key);

  /// Child with [FloatingActionButton].
  final FloatingActionButton fab;

  /// Animated fab controller.
  final AnimatedFabController controller;

  /// The duration for [AnimationController].
  final Duration duration;

  /// The curve for [CurvedAnimation].
  final Curve curve;

  /// Scroll controller.
  final ScrollController scrollController;

  /// Offset that will invoke fab shown.
  final double offset;

  @override
  _ScrollAnimatedFabState createState() => _ScrollAnimatedFabState();
}

class _ScrollAnimatedFabState extends State<ScrollAnimatedFab> with TickerProviderStateMixin<ScrollAnimatedFab> {
  bool _lastShowFab = false;
  AnimationController _animController;
  Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: widget.duration);
    _fabAnimation = CurvedAnimation(parent: _animController, curve: widget.curve);
    widget.controller?.attachAnim(_animController);
    widget.scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  /// Listener used in [ScrollAnimatedFab.scrollController].
  void _scrollListener() {
    bool scrolled = (widget.scrollController?.offset ?? 0) >= widget.offset;
    if (scrolled != _lastShowFab) {
      _lastShowFab = scrolled;
      if (scrolled) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _fabAnimation,
      alignment: FractionalOffset.center,
      child: widget.fab,
    );
  }
}

/// Controller for [ScrollAnimatedFab], includes [show] and [hide] function.
class AnimatedFabController {
  AnimationController _animController;

  /// Register the given [AnimationController] to this controller.
  void attachAnim(AnimationController a) => _animController = a;

  /// Unregister the given [AnimationController] from this controller.
  void detachAnim() => _animController = null;

  @mustCallSuper
  void dispose() {
    _animController = null;
  }

  /// Show the fab in animation.
  void show() {
    _animController?.forward();
  }

  /// Hide the fab in animation.
  void hide() {
    _animController?.reverse();
  }
}
