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
