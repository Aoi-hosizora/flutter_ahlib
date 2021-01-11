import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

/// Append callback function, used in [AppendIndicator].
typedef AppendCallback = Future<void> Function();

/// Represents [AppendIndicator] state.
enum _AppendIndicatorMode {
  drag, // start to show
  armed, // drag far enough
  append, // run the append callback
  done, // append callback is done
  canceled, // canceled by no arming
}

/// Represents [AnimatedCrossFade] in [AppendIndicator] state.
enum _AppendIndicatorProgressMode {
  zero, // show zero progress (value is zero)
  loading, // show loading progress (value is null)
  increasing, // show value increasing progress (use animated progress)
}

/// An indicator widget same with [RefreshIndicator],
/// show in the bottom of view, mainly used for showing append information.
class AppendIndicator extends StatefulWidget {
  const AppendIndicator({
    Key key,
    @required this.child,
    @required this.onAppend,
    this.minHeight,
    this.backgroundColor,
    this.valueColor,
  })  : assert(child != null),
        assert(onAppend != null),
        assert(minHeight == null || minHeight > 0),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// A function that is called when the indicator is appending.
  final AppendCallback onAppend;

  /// The append indicator's min height. This defaults to 4dp.
  final double minHeight;

  /// The append indicator's background color.
  final Color backgroundColor;

  /// The append indicator's color as an animated value.
  final Animation<Color> valueColor;

  @override
  AppendIndicatorState createState() => AppendIndicatorState();
}

/// The state of [AppendIndicator], can be used to show the append indicator, see the [show] method.
class AppendIndicatorState extends State<AppendIndicator> with TickerProviderStateMixin<AppendIndicator> {
  static const _kScaleSlowDuration = Duration(milliseconds: 400);
  static const _kScaleFastDuration = Duration(milliseconds: 150);
  static const _kProgressDuration = Duration(milliseconds: 250);
  static const _kProgressFadeDuration = Duration(milliseconds: 200);
  static const _kScrollThreshold = 75.0;

  AnimationController _sizeController;
  Animation<double> _sizeFactor;
  AnimationController _progressController;
  Animation<double> _progressAnimation;

  _AppendIndicatorMode _mode;
  _AppendIndicatorProgressMode _progressMode;
  Future<void> _pendingAppendFuture;
  double _dragOffset;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(vsync: this);
    _sizeFactor = _sizeController.drive(Tween(begin: 0.0, end: 1.0));
    _progressController = AnimationController(vsync: this);
    _progressAnimation = _progressController.drive(Tween(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  void _start() {
    _sizeController.value = 0.0;
    _progressController.value = 0.0;
    _progressMode = _AppendIndicatorProgressMode.zero;
    _dragOffset = 0;
  }

  bool _onScroll(ScrollNotification notification) {
    var metrics = notification.metrics;

    if (notification is ScrollUpdateNotification) {
      if (metrics.extentAfter == 0.0 && metrics.maxScrollExtent > 0.0 && _mode == null) {
        _start();
        _show(); // show directly
        return false;
      }
    }

    if (notification is ScrollStartNotification) {
      if (metrics.extentAfter == 0.0 && _mode == null) {
        _start();
        _mode = _AppendIndicatorMode.drag;
        if (mounted) setState(() {});
      }
      return false;
    }

    double delta;
    if (_mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed) {
      if (notification is ScrollUpdateNotification) {
        delta = notification.scrollDelta;
      } else if (notification is OverscrollNotification) {
        delta = notification.overscroll;
      }
    }
    if (delta != null) {
      _dragOffset = _dragOffset + delta;
      _sizeController.value = math.pow((_dragOffset / _kScrollThreshold).clamp(0.0, 1.0), 2);
      if (_dragOffset > _kScrollThreshold && _mode == _AppendIndicatorMode.drag) {
        _mode = _AppendIndicatorMode.armed;
      } else if (_dragOffset <= _kScrollThreshold && _mode == _AppendIndicatorMode.armed) {
        _mode = _AppendIndicatorMode.drag;
      }
      return false;
    }

    if (notification is ScrollEndNotification) {
      if (_mode == _AppendIndicatorMode.armed) {
        _show();
      } else if (_mode == _AppendIndicatorMode.drag) {
        _dismiss(_AppendIndicatorMode.canceled);
      }
      return false;
    }

    return false;
  }

  bool _onOverflowScroll(OverscrollIndicatorNotification notification) {
    if (_mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  void _show() async {
    if (!mounted) {
      return;
    }

    final Completer<void> completer = Completer<void>();
    _pendingAppendFuture = completer.future;

    _mode = _AppendIndicatorMode.append;
    if (mounted) setState(() {});
    await _sizeController.animateTo(1.0, duration: _kScaleFastDuration);
    _progressMode = _AppendIndicatorProgressMode.loading;
    if (mounted) setState(() {});

    widget.onAppend()?.whenComplete(() async {
      if (mounted && _mode == _AppendIndicatorMode.append) {
        completer.complete();
        _dismiss(_AppendIndicatorMode.done);
      }
    });
  }

  void _dismiss(_AppendIndicatorMode newMode) async {
    _mode = newMode;
    if (mounted) setState(() {});

    if (_mode == _AppendIndicatorMode.done) {
      _progressMode = _AppendIndicatorProgressMode.increasing;
      if (mounted) setState(() {});
      await Future.delayed(_kProgressFadeDuration);
      await _progressController.animateTo(1.0, duration: _kProgressDuration);
    }
    await _sizeController.animateTo(0.0, duration: _kScaleSlowDuration, curve: Curves.easeOutCubic);

    _mode = null;
    if (mounted) setState(() {});
  }

  /// Show the indicator and run the callback as if it had been started interactively.
  /// If this method is called while the callback is running, it quietly does nothing.
  Future<void> show() {
    if (_mode == null) {
      _start();
      _show();
    }
    return _pendingAppendFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (s) => _onScroll(s),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (s) => _onOverflowScroll(s),
            child: widget.child,
          ),
        ),
        if (_mode != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SizeTransition(
                sizeFactor: _sizeFactor,
                axis: Axis.horizontal,
                child: AnimatedCrossFade(
                  duration: _kProgressFadeDuration,
                  crossFadeState: _progressMode == _AppendIndicatorProgressMode.increasing ? CrossFadeState.showSecond : CrossFadeState.showFirst /* loading || zero */,
                  firstChild: LinearProgressIndicator(
                    value: _progressMode == _AppendIndicatorProgressMode.zero ? 0 : null /* loading || increasing */,
                    minHeight: widget.minHeight,
                    backgroundColor: widget.backgroundColor,
                    valueColor: widget.valueColor,
                  ),
                  secondChild: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (_, __) => LinearProgressIndicator(
                      value: _progressAnimation.value,
                      minHeight: widget.minHeight,
                      backgroundColor: widget.backgroundColor,
                      valueColor: widget.valueColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
