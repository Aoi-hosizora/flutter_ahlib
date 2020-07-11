import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter/material.dart';

/// More function of `ScrollController`
///
/// includeing: `scrollWithAnimate`, `scrollTop`, `scrollBottom`, `scrollDown`, `scrollUp`,
/// `swipeDown` (need `attachAppend`), `refresh` (need `attachRefresh`)
class ScrollMoreController extends ScrollController {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  void attachAppend(GlobalKey<AppendIndicatorState> s) => _appendIndicatorKey = s;
  void attachRefresh(GlobalKey<RefreshIndicatorState> r) => _refreshIndicatorKey = r;
  void detachAppend() => _appendIndicatorKey = null;
  void detachRefresh() => _refreshIndicatorKey = null;

  ScrollController Function() _controllerFunc;
  ScrollController get _controller {
    var a = _controllerFunc?.call();
    print(a == null);
    return a;
  }

  void bind(ScrollController Function() func) => _controllerFunc = func;
  void unbind() => _controllerFunc = null;

  @override
  void addListener(VoidCallback listener) {
    var f = _controller?.addListener ?? super.addListener;
    f(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    var f = _controller?.removeListener ?? super.removeListener;
    f(listener);
  }

  @protected
  @override
  void notifyListeners() {
    var f = _controller?.notifyListeners ?? super.notifyListeners;
    return f();
  }

  @override
  Future<void> animateTo(double offset, {@required Duration duration, @required Curve curve}) {
    var f = _controller?.animateTo ?? super.animateTo;
    return f(offset, duration: duration, curve: curve);
  }

  @override
  void jumpTo(double value) {
    var f = _controller?.jumpTo ?? super.jumpTo;
    return f(value);
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    var f = _controller?.createScrollPosition ?? super.createScrollPosition;
    return f(physics, context, oldPosition);
  }

  @override
  bool get hasClients => _controller?.hasClients ?? super.hasClients;

  @override
  bool get hasListeners => _controller?.hasListeners ?? super.hasListeners;

  @override
  double get initialScrollOffset => _controller?.initialScrollOffset ?? super.initialScrollOffset;

  @override
  bool get keepScrollOffset => _controller?.keepScrollOffset ?? super.keepScrollOffset;

  @override
  double get offset => _controller?.offset ?? super.offset;

  @override
  ScrollPosition get position => _controller?.position ?? super.position;

  @override
  @protected
  Iterable<ScrollPosition> get positions => _controller?.positions ?? super.positions;

  void scrollWithAnimate(double offset) {
    animateTo(
      offset,
      curve: Curves.easeOutCirc,
      duration: Duration(milliseconds: 500),
    );
  }

  void scrollTop() {
    scrollWithAnimate(0.0);
  }

  /// BUG!!!
  void scrollBottom() {
    scrollWithAnimate(position.maxScrollExtent);
  }

  void scrollDown({int scrollOffset = 50}) {
    scrollWithAnimate(offset + scrollOffset);
  }

  void scrollUp({int scrollOffset = 50}) {
    scrollWithAnimate(offset - scrollOffset);
  }

  Future<void> swipeDown() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }

  Future<void> refresh() {
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }
}
