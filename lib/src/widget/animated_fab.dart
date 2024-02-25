import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

/// The default duration of [AnimatedFab] and [ScrollAnimatedFab].
const _kDefaultDuration = Duration(milliseconds: 250);

/// The default curve of [AnimatedFab] and [ScrollAnimatedFab].
const _kDefaultCurve = Curves.easeOutBack;

/// The default scroll offset of [ScrollAnimatedFab].
const _kDefaultScrollOffset = 50.0;

/// A [FloatingActionButton] wrapped by some animation transitions in default, which does
/// animation depended by [show] switcher.
class AnimatedFab extends StatefulWidget {
  const AnimatedFab({
    Key? key,
    required this.fab,
    this.controller,
    this.duration = _kDefaultDuration,
    this.curve = _kDefaultCurve,
    required this.show,
    this.customBuilder,
  }) : super(key: key);

  /// The widget below this widget in the tree, typically is a [FloatingActionButton] widget.
  final Widget fab;

  /// The controller of this widget.
  final AnimatedFabController? controller;

  /// The duration of the animation to show this fab.
  final Duration duration;

  /// The curve of the animation to show this fab.
  final Curve curve;

  /// The switcher to show this fab or not.
  final bool show;

  /// The custom widget builder with given [Animation] and passed [fab].
  final Widget Function(Animation<double> animation, Widget fab)? customBuilder;

  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with SingleTickerProviderStateMixin {
  late final _controller = widget.controller ?? AnimatedFabController();
  late final _animController = AnimationController(vsync: this, duration: widget.duration);
  late final _animation = CurvedAnimation(parent: _animController, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    _controller.attachAnim(_animController);
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) => _onShowChanged(widget.show));
  }

  @override
  void dispose() {
    _controller.detachAnim();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void _onShowChanged(bool show) {
    show ? _controller.show() : _controller.hide();
  }

  @override
  void didUpdateWidget(covariant AnimatedFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.show != widget.show) {
      _onShowChanged(widget.show);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(_animation, widget.fab);
    }
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        alignment: FractionalOffset.center,
        child: widget.fab,
      ),
    );
  }
}

/// A condition enum to decide how [ScrollAnimatedFab] does animation when scrolling.
enum ScrollAnimatedCondition {
  /// Shows fab when current scroll offset is larger then given threshold.
  offset,

  /// Shows fab when current scroll offset is less then given threshold.
  reverseOffset,

  /// Shows fab when scroll view is swiped up, which makes it scrolls down.
  direction,

  /// Shows fab when scroll view is swiped down, which makes it scrolls up.
  reverseDirection,

  /// Always shows fab.
  forceShow,

  /// Always hides fab.
  forceHide,

  /// Shows fab depended by custom behavior, defaults to show fab always.
  custom,
}

/// A [FloatingActionButton] wrapped by some animation transitions in default, which does
/// animation depended by scrolling.
class ScrollAnimatedFab extends StatefulWidget {
  const ScrollAnimatedFab({
    Key? key,
    required this.fab,
    this.controller,
    this.duration = _kDefaultDuration,
    this.curve = _kDefaultCurve,
    required this.scrollController,
    this.condition = ScrollAnimatedCondition.offset,
    this.offset = _kDefaultScrollOffset,
    this.customBuilder,
    this.customBehavior,
  })  : assert(offset >= 0),
        super(key: key);

  /// The widget below this widget in the tree, typically is a [FloatingActionButton] widget.
  final Widget fab;

  /// The controller of this widget.
  final AnimatedFabController? controller;

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

  /// The custom widget builder with given [Animation] and passed [fab].
  final Widget Function(Animation<double> animation, Widget fab)? customBuilder;

  /// The custom behavior with given [ScrollPosition], used for [ScrollAnimatedCondition.custom].
  final bool Function(ScrollPosition pos)? customBehavior;

  @override
  _ScrollAnimatedFabState createState() => _ScrollAnimatedFabState();
}

class _ScrollAnimatedFabState extends State<ScrollAnimatedFab> with SingleTickerProviderStateMixin {
  late final _controller = widget.controller ?? AnimatedFabController();
  late final _animController = AnimationController(vsync: this, duration: widget.duration);
  late final _animation = CurvedAnimation(parent: _animController, curve: widget.curve);

  @override
  void initState() {
    super.initState();
    _controller.attachAnim(_animController);
    widget.scrollController.addListener(_scrollListener);
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) => _scrollListener());
  }

  @override
  void dispose() {
    _controller.detachAnim();
    if (widget.controller == null) {
      _controller.dispose();
    }
    widget.scrollController.removeListener(_scrollListener);
    _animController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ScrollAnimatedFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition || oldWidget.offset != widget.offset) {
      _scrollListener();
    }
  }

  /// Subscribes the scroll offset and direction from given scroll controller.
  void _scrollListener() {
    ScrollPosition? positionGetter() {
      if (!widget.scrollController.hasClients || !widget.scrollController.position.hasContentDimensions) {
        return null;
      }
      return widget.scrollController.position;
    }

    bool canShow = false;
    switch (widget.condition) {
      case ScrollAnimatedCondition.forceShow:
        canShow = true;
        break;
      case ScrollAnimatedCondition.forceHide:
        canShow = false;
        break;
      case ScrollAnimatedCondition.offset:
        var pos = positionGetter();
        if (pos == null) return;
        canShow = pos.extentBefore > widget.offset;
        break;
      case ScrollAnimatedCondition.reverseOffset:
        var pos = positionGetter();
        if (pos == null) return;
        canShow = pos.extentAfter > widget.offset;
        break;
      case ScrollAnimatedCondition.direction:
        var pos = positionGetter();
        if (pos == null) return;
        canShow = pos.extentBefore > 0 && pos.userScrollDirection == ScrollDirection.forward;
        break;
      case ScrollAnimatedCondition.reverseDirection:
        var pos = positionGetter();
        if (pos == null) return;
        canShow = pos.extentAfter > 0 && pos.userScrollDirection == ScrollDirection.reverse;
        break;
      case ScrollAnimatedCondition.custom:
        var pos = positionGetter();
        if (pos == null) return;
        canShow = widget.customBehavior?.call(pos) ?? true;
        break;
    }
    if (_controller.hasClient) {
      canShow ? _controller.show() : _controller.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(_animation, widget.fab);
    }
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        alignment: FractionalOffset.center,
        child: widget.fab,
      ),
    );
  }
}

/// A controller of [AnimatedFab] and [ScrollAnimatedFab], which is used to show and hide fab
/// with animation.
class AnimatedFabController {
  /// Constructs a default [AnimatedFabController] with no animation controller attached.
  AnimatedFabController();

  // The animation controller from [AnimatedFab] and [ScrollAnimatedFab].
  AnimationController? _animController;

  /// Registers the given [AnimationController] to this controller. Note that this will
  /// detaches the attached [AnimationController] first.
  void attachAnim(AnimationController a) => _animController = a;

  /// Unregisters the given [AnimationController] from this controller.
  void detachAnim() => _animController = null;

  @mustCallSuper
  void dispose() {
    _animController = null;
  }

  /// Returns the inner animation controller.
  AnimationController get animController {
    assert(_animController != null, 'animation controller must not be null');
    return _animController!;
  }

  /// Returns true if there is an [AnimationController] attached to the controller.
  bool get hasClient => _animController != null;

  /// Returns true if the fab has already shown.
  bool get isShown => animController.value == 1.0;

  /// Returns true if the fab has already hided.
  bool get isHided => animController.value == 0.0;

  /// Returns true if the fab is animating.
  bool get isAnimating => animController.isAnimating;

  /// Returns the status of attached animation.
  AnimationStatus get status => animController.status;

  /// Shows the fab with animation manually. If fab is showing or has already shown, this
  /// action will be ignored.
  void show() {
    if (!isAnimating && isShown) {
      return;
    }
    if (isAnimating && animController.status == AnimationStatus.forward) {
      return;
    }
    animController.forward();
  }

  /// Hides the fab with animation manually. If fab is hiding or has already hided, this
  /// action will be ignored.
  void hide() {
    if (!isAnimating && isHided) {
      return;
    }
    if (isAnimating && animController.status == AnimationStatus.reverse) {
      return;
    }
    animController.reverse();
  }
}
