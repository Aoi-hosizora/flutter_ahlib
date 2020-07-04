import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// `null` -> not contain Positioned,
/// `none` -> is positioned animating,
/// `appending` -> show and refreshing
enum _AppendIndicatorMode {
  none,
  appending,
}

/// A indicator same with `RefreshIndicator`, show in the bottom of view, mainly for showing append infomation.
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

  final Widget child;
  final AppendCallback onAppend;
  final Color backgroundColor;
  final Animation<Color> valueColor;

  @override
  AppendIndicatorState createState() => AppendIndicatorState();
}

/// State for `AppendIndicator`, only `show()` can be used.
class AppendIndicatorState extends State<AppendIndicator> {
  _AppendIndicatorMode _mode;
  Future<void> _pendingRefreshFuture;
  var _kAnimatedDuration = Duration(milliseconds: 500);

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

  void _show() {
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
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

  Future<void> show() {
    if (_mode == null) {
      _show();
    }
    return _pendingRefreshFuture;
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
