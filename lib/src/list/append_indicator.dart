import 'dart:async';

import 'package:flutter/material.dart';

/// Used in [AnimatedOpacity] and [onAppend.whenComplete].
const _kAnimatedDuration = Duration(milliseconds: 500);

/// Represents indicator's state.
enum _AppendIndicatorMode {
  /// Indicate is now positioned animating.
  none,

  /// Indicate is now showing and refreshing.
  appending,
}

/// Append callback function, used in [AppendIndicator].
typedef AppendCallback = Future<void> Function();

/// An indicator widget same with [RefreshIndicator],
/// show in the bottom of view, mainly used for showing append information.
class AppendIndicator extends StatefulWidget {
  const AppendIndicator({
    Key key,
    @required this.child,
    @required this.onAppend,
    this.backgroundColor,
    this.valueColor,
  })  : assert(child != null),
        assert(onAppend != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// A function that's called when the indicator is appending.
  final AppendCallback onAppend;

  /// The progress indicator's background color.
  final Color backgroundColor;

  /// The progress indicator's color as an animated value.
  final Animation<Color> valueColor;

  @override
  AppendIndicatorState createState() => AppendIndicatorState();
}

/// The state of [AppendIndicator], can be used to show the append indicator, see the [show] method.
class AppendIndicatorState extends State<AppendIndicator> {
  _AppendIndicatorMode _mode;
  Future<void> _pendingAppendFuture;
  double _extent = -1;
  double _pointerDownPosition = 0;

  bool _onScroll(ScrollNotification s, void Function() action) {
    _extent = s.metrics.maxScrollExtent;
    bool short = _extent == 0;
    bool bottom = s.metrics.pixels >= s.metrics.maxScrollExtent && !s.metrics.outOfRange;
    if (!short && bottom) {
      action();
    }
    return true;
  }

  void _onPointerDown(PointerDownEvent e) {
    _pointerDownPosition = e.position?.dy ?? 0;
  }

  void _onPointerMove(PointerMoveEvent e, void Function() action) {
    if (e.down) {
      bool short = _extent == 0;
      if (short && _pointerDownPosition > e.position?.dy ?? 0) {
        action();
      }
    }
  }

  /// Inner implementation of [show], used in [show], [_onScroll] and [_onPointerMove].
  void _show() {
    final Completer<void> completer = Completer<void>();
    _pendingAppendFuture = completer.future;
    if (!mounted || _mode != null) {
      return;
    }

    _mode = _AppendIndicatorMode.appending;
    if (mounted) setState(() {});

    final result = widget.onAppend();
    result?.whenComplete(() async {
      if (mounted && _mode == _AppendIndicatorMode.appending) {
        completer.complete();
        _mode = _AppendIndicatorMode.none;
        if (mounted) setState(() {});

        await Future.delayed(_kAnimatedDuration);
        _mode = null;
        if (mounted) setState(() {});
      }
    });
  }

  /// Show the indicator and run the callback as if it had been started interactively.
  /// If this method is called while the callback is running, it quietly does nothing.
  Future<void> show() {
    if (_mode == null) {
      _show();
    }
    return _pendingAppendFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (s) => _onScroll(s, _show),
          child: Listener(
            onPointerDown: (m) => _onPointerDown(m),
            onPointerMove: (m) => _onPointerMove(m, _show),
            child: widget.child,
          ),
        ),
        if (_mode != null)
          Positioned(
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _mode == _AppendIndicatorMode.none ? 0 : 1,
              duration: _kAnimatedDuration,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: LinearProgressIndicator(
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
