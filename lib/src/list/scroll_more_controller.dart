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

  ScrollController Function() _bindCtrlFunc;
  ScrollController get _bindedCtrl => _bindCtrlFunc?.call();

  void bind(ScrollController Function() func) => _bindCtrlFunc = func;
  void unbind() => _bindCtrlFunc = null;

  @mustCallSuper
  @override
  void dispose() {
    detachAppend();
    detachRefresh();
    unbind();
    super.dispose();
  }

  @override
  void addListener(VoidCallback listener) {
    var f = _bindedCtrl?.addListener ?? super.addListener;
    f(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    var f = _bindedCtrl?.removeListener ?? super.removeListener;
    f(listener);
  }

  @protected
  @override
  void notifyListeners() {
    var f = _bindedCtrl?.notifyListeners ?? super.notifyListeners;
    return f();
  }

  @override
  Future<void> animateTo(double offset, {@required Duration duration, @required Curve curve}) {
    var f = _bindedCtrl?.animateTo ?? super.animateTo;
    return f(offset, duration: duration, curve: curve);
  }

  @override
  void jumpTo(double value) {
    var f = _bindedCtrl?.jumpTo ?? super.jumpTo;
    return f(value);
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    var f = _bindedCtrl?.createScrollPosition ?? super.createScrollPosition;
    return f(physics, context, oldPosition);
  }

  @override
  bool get hasClients => _bindedCtrl?.hasClients ?? super.hasClients;

  @override
  bool get hasListeners => _bindedCtrl?.hasListeners ?? super.hasListeners;

  @override
  double get initialScrollOffset => _bindedCtrl?.initialScrollOffset ?? super.initialScrollOffset;

  @override
  bool get keepScrollOffset => _bindedCtrl?.keepScrollOffset ?? super.keepScrollOffset;

  @override
  double get offset => _bindedCtrl?.offset ?? super.offset;

  @override
  ScrollPosition get position => _bindedCtrl?.position ?? super.position;

  @override
  @protected
  Iterable<ScrollPosition> get positions => _bindedCtrl?.positions ?? super.positions;

  /// Scroll with `easeOutCirc` and 500ms
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
