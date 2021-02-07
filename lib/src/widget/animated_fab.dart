import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// The default duration of [AnimatedFab] and [ScrollAnimatedFab].
const _kDefaultDuration = const Duration(milliseconds: 250);

/// The default curve of [AnimatedFab] and [ScrollAnimatedFab].
const _kDefaultCurve = Curves.easeOutBack;

/// The default scroll offset of [ScrollAnimatedFab].
const _kDefaultScrollOffset = 50.0;

/// A [FloatingActionButton] wrapped by [ScaleTransition] that will do animation with [show] switcher.
class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    Key key,
    @required this.fab,
    this.controller,
    this.duration = _kDefaultDuration,
    this.curve = _kDefaultCurve,
    this.show = false,
  })  : assert(fab != null),
        assert(duration != null),
        assert(curve != null),
        assert(show != null),
        super(key: key);

  /// The widget below this widget in the tree, which is a [FloatingActionButton].
  final Widget fab;

  /// The controller of this widget.
  final AnimatedFabController controller;

  /// The duration of the animation to show this fab.
  final Duration duration;

  /// The curve of the animation to show this fab.
  final Curve curve;

  /// The switcher to show this fab or not, defaults to false.
  final bool show;

  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with TickerProviderStateMixin<AnimatedFab> {
  AnimationController _animController;
  Animation<double> _fabAnimation;
  bool _lastShow; // store the last state

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
    if (_lastShow == null || widget.show != _lastShow) {
      _lastShow = widget.show;
      if (widget.show) {
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

/// A condition enum to do animation when scrolling used in [ScrollAnimatedFab].
enum ScrollAnimatedCondition {
  /// Uses scroll offset as the animation condition.
  offset,

  /// Uses scroll direction as the animation condition.
  direction,
}

/// A [FloatingActionButton] wrapped by [ScaleTransition] that will do animation when scrolling.
class ScrollAnimatedFab extends StatefulWidget {
  const ScrollAnimatedFab({
    Key key,
    @required this.fab,
    this.controller,
    this.duration = _kDefaultDuration,
    this.curve = _kDefaultCurve,
    @required this.scrollController,
    this.condition = ScrollAnimatedCondition.offset,
    this.offset = _kDefaultScrollOffset,
  })  : assert(fab != null),
        assert(duration != null),
        assert(curve != null),
        assert(scrollController != null),
        assert(condition != null),
        assert(offset != null && offset >= 0),
        super(key: key);

  /// The widget below this widget in the tree, which is a [FloatingActionButton].
  final Widget fab;

  /// The controller of this widget.
  final AnimatedFabController controller;

  /// The duration of the animation to show this fab.
  final Duration duration;

  /// The curve of the animation to show this fab.
  final Curve curve;

  /// The scroll controller to detect scroll offset.
  final ScrollController scrollController;

  /// The condition to do animation, defaults to [ScrollAnimatedCondition.offset].
  final ScrollAnimatedCondition condition;

  /// The offset threshold of invoking fab shown when used [ScrollAnimatedCondition.offset].
  final double offset;

  @override
  _ScrollAnimatedFabState createState() => _ScrollAnimatedFabState();
}

class _ScrollAnimatedFabState extends State<ScrollAnimatedFab> with TickerProviderStateMixin<ScrollAnimatedFab> {
  AnimationController _animController;
  Animation<double> _fabAnimation;
  bool _lastShow; // store the last state

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: widget.duration);
    _fabAnimation = CurvedAnimation(parent: _animController, curve: widget.curve);

    widget.scrollController.addListener(_scrollListener);
    widget.controller?.attachAnim(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  /// Subscribes the scroll offset and direction from given scroll controller.
  void _scrollListener() {
    assert(widget.condition != null);

    bool canShow = false;
    if (widget.condition == ScrollAnimatedCondition.offset) {
      canShow = (widget.scrollController?.offset ?? 0) >= widget.offset;
    } else if (widget.condition == ScrollAnimatedCondition.direction) {
      var pos = widget.scrollController?.position;
      canShow = (pos?.extentBefore ?? 0) > 0 && pos?.userScrollDirection == ScrollDirection.forward;
    }

    if (canShow != _lastShow) {
      _lastShow = canShow;
      if (canShow) {
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

/// A controller of [AnimatedFab] and [ScrollAnimatedFab], includes [show] and [hide] methods.
class AnimatedFabController {
  AnimationController _animController;

  /// Registers the given [AnimationController] to this controller.
  void attachAnim(AnimationController a) => _animController = a;

  /// Unregisters the given [AnimationController] from this controller.
  void detachAnim() => _animController = null;

  @mustCallSuper
  void dispose() {
    _animController = null;
  }

  /// Shows the fab with animation.
  void show() {
    _animController?.forward();
  }

  /// Hides the fab with animation.
  void hide() {
    _animController?.reverse();
  }
}
