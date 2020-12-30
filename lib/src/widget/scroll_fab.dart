import 'package:flutter/material.dart';

/// A [FloatingActionButton] that will do animation when scrolling.
class ScrollFloatingActionButton extends StatefulWidget {
  const ScrollFloatingActionButton({
    Key key,
    @required this.fab,
    this.fabController,
    this.scrollController,
    this.offset = 50,
    this.duration = const Duration(milliseconds: 250),
    this.curve = const Interval(0, 1, curve: Curves.easeOutBack),
  })  : assert(fab != null),
        assert(offset != null && offset >= 0),
        assert(duration != null),
        assert(curve != null),
        super(key: key);

  /// Content with [FloatingActionButton].
  final FloatingActionButton fab;

  /// Scroll fab controller.
  final ScrollFabController fabController;

  /// Scroll controller.
  final ScrollController scrollController;

  /// Offset that invoke fab shown.
  final double offset;

  /// The duration for [AnimationController].
  final Duration duration;

  /// The curve for [CurvedAnimation].
  final Curve curve;

  @override
  _ScrollFloatingActionButtonState createState() => _ScrollFloatingActionButtonState();
}

class _ScrollFloatingActionButtonState extends State<ScrollFloatingActionButton> with TickerProviderStateMixin<ScrollFloatingActionButton> {
  bool _lastShowFab = false;
  AnimationController _animController;
  Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: widget.duration);
    _fabAnimation = CurvedAnimation(parent: _animController, curve: widget.curve);
    widget.fabController?.attachAnim(_animController);
    widget.scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  /// Listener used in [ScrollFloatingActionButton.scrollController].
  void _scrollListener() {
    bool scrolled = widget.scrollController?.offset ?? 0 >= widget.offset;
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

/// Controller for [ScrollFloatingActionButton], includes [show] and [hide] function.
class ScrollFabController {
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
