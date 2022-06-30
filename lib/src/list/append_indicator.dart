import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

/// An append callback function used in [AppendIndicator].
typedef AppendCallback = Future<void> Function();

/// An indicator mode used in [AppendIndicator].
enum _AppendIndicatorMode {
  drag, // start to show
  armed, // drag far enough
  append, // run the append callback
  done, // append callback is done
  canceled, // canceled by no arming
}

/// An indicator widget same with [RefreshIndicator], shown in the bottom of view, mainly used for showing append information.
class AppendIndicator extends StatefulWidget {
  const AppendIndicator({
    Key? key,
    required this.child,
    required this.onAppend,
    this.minHeight = 5.0,
    this.backgroundColor,
    this.valueColor,
  })  : assert(minHeight == null || minHeight > 0),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function that is called when appending.
  final AppendCallback onAppend;

  /// The min height of this indicator, defaults to 5dp.
  final double? minHeight;

  /// The background color of this indicator.
  final Color? backgroundColor;

  /// The value color of this indicator.
  final Animation<Color>? valueColor;

  @override
  AppendIndicatorState createState() => AppendIndicatorState();
}

/// TODO [RefreshIndicator] and [RefreshIndicatorState]

/// The state of [AppendIndicator], can be used to show the append indicator, see the [show] method.
class AppendIndicatorState extends State<AppendIndicator> with TickerProviderStateMixin<AppendIndicator> {
  static const _kScaleShrinkDuration = Duration(milliseconds: 400);
  static const _kScaleExpandDuration = Duration(milliseconds: 100);
  static const _kScrollThreshold = 92.0;

  late AnimationController _sizeController;
  late Animation<double> _sizeFactor;

  _AppendIndicatorMode? _mode;
  Future<void>? _pendingAppendFuture;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(vsync: this);
    _sizeFactor = _sizeController.drive(Tween(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  void _start() {
    _sizeController.value = 0.0;
    _dragOffset = 0;
  }

  bool _onScroll(ScrollNotification notification) {
    var metrics = notification.metrics;

    // scroll update (directly)
    if (notification is ScrollUpdateNotification) {
      if (metrics.extentAfter == 0.0 && metrics.maxScrollExtent > 0.0 && _mode == null) {
        _start();
        _show(); // show directly
        return false;
      }
    }

    // scroll start
    if (notification is ScrollStartNotification) {
      if (metrics.extentAfter == 0.0 && _mode == null) {
        _start();
        _mode = _AppendIndicatorMode.drag;
        if (mounted) setState(() {});
      }
      return false;
    }

    // scroll update
    double? delta;
    if (_mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed) {
      if (notification is ScrollUpdateNotification) {
        delta = notification.scrollDelta;
      } else if (notification is OverscrollNotification) {
        delta = notification.overscroll;
      }
    }
    if (delta != null) {
      _dragOffset = _dragOffset + delta;
      _sizeController.value = math.pow((_dragOffset / _kScrollThreshold).clamp(0.0, 1.0), 2) as double;
      if (_dragOffset > _kScrollThreshold && _mode == _AppendIndicatorMode.drag) {
        _mode = _AppendIndicatorMode.armed;
      } else if (_dragOffset <= _kScrollThreshold && _mode == _AppendIndicatorMode.armed) {
        _mode = _AppendIndicatorMode.drag;
      }
      return false;
    }

    // scroll end
    if (notification is ScrollEndNotification) {
      if (_mode == _AppendIndicatorMode.armed) {
        _show();
      } else if (_mode == _AppendIndicatorMode.drag) {
        _dismiss(_AppendIndicatorMode.canceled); // -> canceled
      }
      return false;
    }

    return false;
  }

  bool _onOverflowScroll(OverscrollIndicatorNotification notification) {
    if (_mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed) {
      notification.disallowIndicator(); // disable glow
      return true;
    }
    return false;
  }

  /// Shows animation with "-> expand -> loading".
  void _show() async {
    if (!mounted) {
      return;
    }

    final Completer<void> completer = Completer<void>();
    _pendingAppendFuture = completer.future;

    // -> append
    _mode = _AppendIndicatorMode.append;
    if (mounted) setState(() {});
    await _sizeController.animateTo(1.0, duration: _kScaleExpandDuration); // expand

    var result = widget.onAppend(); // loading
    result.whenComplete(() async {
      if (mounted && _mode == _AppendIndicatorMode.append) {
        completer.complete();
        _dismiss(_AppendIndicatorMode.done); // -> done
      }
    });
  }

  /// Show animation with "-> shrink".
  void _dismiss(_AppendIndicatorMode newMode) async {
    assert(newMode == _AppendIndicatorMode.append || newMode == _AppendIndicatorMode.canceled);

    // -> cancel || -> done
    _mode = newMode;
    if (mounted) setState(() {});
    await _sizeController.animateTo(0.0, duration: _kScaleShrinkDuration, curve: Curves.easeOutCubic); // shrink

    // -> null
    _mode = null;
    if (mounted) setState(() {});
  }

  /// Shows the indicator and runs the callback as if it had been started interactively. If this method
  /// is called while the callback is running, it quietly does nothing.
  Future<void> show() {
    if (_mode == null) {
      _start();
      _show();
    }
    return _pendingAppendFuture ?? Future.value();
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
                child: LinearProgressIndicator(
                  // value: 0 (drag, armed, canceled) -> null (append, done)
                  value: _mode == _AppendIndicatorMode.append || _mode == _AppendIndicatorMode.done ? null : 0,
                  minHeight: widget.minHeight,
                  backgroundColor: widget.backgroundColor,
                  valueColor: widget.valueColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
