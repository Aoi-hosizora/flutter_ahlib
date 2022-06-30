import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';

/// The minimum height of [LinearProgressIndicator] used in [AppendIndicator].
const _kMinimumIndicatorHeight = 5.0;

/// The duration of scale shrinking used in [AppendIndicator].
const _kScaleShrinkDuration = Duration(milliseconds: 400);

/// The curve of scale shrinking used in [AppendIndicator].
const _kScaleShrinkCurve = Curves.easeOutCubic;

/// The duration of scale expanding used in [AppendIndicator].
const _kScaleExpandDuration = Duration(milliseconds: 100);

/// The scroll threshold used in [AppendIndicator], the state of indicator will turn to armed when
/// the dragging offset is larger than this threshold.
const _kArmedScrollThreshold = 92.0;

/// The signature for a function which is used by [AppendIndicator.onAppend]. I0t is called when user
/// has dragged a [AppendIndicator] far enough to demonstrate that they want the app to append data.
typedef AppendCallback = Future<void> Function();

/// An indicator mode, or state machine states, which is used in [AppendIndicator].
enum _AppendIndicatorMode {
  drag, // pointer is down
  armed, // drag far enough
  append, // run the append callback
  done, // append callback is done
  canceled, // canceled by no arming
}

/// An indicator widget which is similar with [RefreshIndicator], uses [LinearProgressIndicator] shown
/// in the bottom of view as indicator, mainly used for showing append information.
class AppendIndicator extends StatefulWidget {
  const AppendIndicator({
    Key? key,
    required this.child,
    required this.onAppend,
    this.minHeight = _kMinimumIndicatorHeight,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
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

  /// The color of this indicator, and this is only used if [valueColor] is null.
  final Color? color;

  /// The value color of this indicator.
  final Animation<Color?>? valueColor;

  /// The check that specifies whether a [ScrollNotification] should be handled by this widget,
  /// defaults to [defaultScrollNotificationPredicate].
  final ScrollNotificationPredicate? notificationPredicate;

  @override
  AppendIndicatorState createState() => AppendIndicatorState();
}

/// The state of [AppendIndicator], can be used to show the append indicator at the bottom,
/// which is a [LinearProgressIndicator].
class AppendIndicatorState extends State<AppendIndicator> with TickerProviderStateMixin<AppendIndicator> {
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

  /// Starts and initializes the drag offset and animation size controller value.
  void _start() {
    assert(_mode == null);

    _dragOffset = 0.0;
    _sizeController.value = 0.0;
  }

  /// Handles scroll notification.
  bool _onScroll(ScrollNotification notification) {
    var predicate = widget.notificationPredicate ?? defaultScrollNotificationPredicate;
    if (!predicate(notification)) {
      return false;
    }

    // metrics is used to check if the indicator should start
    var metrics = notification.metrics;

    // scroll update (directly)
    if (notification is ScrollUpdateNotification && notification.dragDetails != null) {
      if (metrics.extentAfter == 0.0 && metrics.maxScrollExtent > 0.0 && _mode == null) {
        _start();
        _show(); // show directly
        return false;
      }
    }

    // scroll start
    if (notification is ScrollStartNotification && notification.dragDetails != null) {
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
      _sizeController.value = math.pow((_dragOffset / _kArmedScrollThreshold).clamp(0.0, 1.0), 2).toDouble();
      if (_dragOffset > _kArmedScrollThreshold && _mode == _AppendIndicatorMode.drag) {
        _mode = _AppendIndicatorMode.armed;
      } else if (_dragOffset <= _kArmedScrollThreshold && _mode == _AppendIndicatorMode.armed) {
        _mode = _AppendIndicatorMode.drag;
      }
      return false;
    }

    // scroll end
    if (notification is ScrollEndNotification) {
      if (_mode == _AppendIndicatorMode.armed) {
        _show(); // -> append -> done
      } else if (_mode == _AppendIndicatorMode.drag) {
        _dismiss(_AppendIndicatorMode.canceled); // -> canceled
      } else {
        // do nothing
      }
      return false;
    }

    return false;
  }

  /// Handles glow notification.
  bool _onOverflowScroll(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed) {
      // _mode == _AppendIndicatorMode.drag || _mode == _AppendIndicatorMode.armed
      notification.disallowIndicator(); // disable glow
      return true;
    }
    return false;
  }

  /// Shows animation as "-> expand -> loading".
  void _show() async {
    if (!mounted || _mode == _AppendIndicatorMode.append) {
      return;
    }

    final Completer<void> completer = Completer<void>();
    _pendingAppendFuture = completer.future;

    // -> append
    _mode = _AppendIndicatorMode.append;
    if (mounted) setState(() {});
    await _sizeController.animateTo(1.0, duration: _kScaleExpandDuration); // expand

    var appendResult = widget.onAppend(); // loading
    appendResult.whenComplete(() {
      if (mounted && _mode == _AppendIndicatorMode.append) {
        completer.complete();
        _dismiss(_AppendIndicatorMode.done); // -> done
      }
    });
  }

  /// Shows animation as "-> shrink".
  Future<void> _dismiss(_AppendIndicatorMode newMode) async {
    await Future<void>.value();
    assert(newMode == _AppendIndicatorMode.canceled || newMode == _AppendIndicatorMode.done);

    // -> cancel || -> done
    _mode = newMode;
    if (mounted) setState(() {});
    await _sizeController.animateTo(0.0, duration: _kScaleShrinkDuration, curve: _kScaleShrinkCurve); // shrink

    // -> null
    if (_mode == newMode) {
      _dragOffset = 0.0;
      _mode = null;
      if (mounted) setState(() {});
    }
  }

  /// Shows the indicator and runs the callback as if it had been started interactively. If this
  /// method is called while the callback is running, it quietly does nothing.
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
                  minHeight: widget.minHeight ?? _kMinimumIndicatorHeight,
                  backgroundColor: widget.backgroundColor,
                  color: widget.color,
                  valueColor: widget.valueColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
