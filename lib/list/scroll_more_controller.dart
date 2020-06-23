import 'package:flutter_ahlib/list/append_indicator.dart';
import 'package:flutter/material.dart';

class ScrollMoreController extends ScrollController {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  void attachAppend(GlobalKey<AppendIndicatorState> s) => _appendIndicatorKey = s;
  void attachRefresh(GlobalKey<RefreshIndicatorState> r) => _refreshIndicatorKey = r;
  void detachAppend() => _appendIndicatorKey = null;
  void detachRefresh() => _refreshIndicatorKey = null;

  void scrollWithAnimate(double offset) {
    if (offset < 0) {
      offset = 0;
    } else if (offset > position.maxScrollExtent) {
      offset = position.maxScrollExtent;
    }
    animateTo(
      offset,
      curve: Curves.easeOutCirc,
      duration: Duration(milliseconds: 500),
    );
  }

  void scrollTop() {
    scrollWithAnimate(0.0);
  }

  void scrollBottom() {
    scrollWithAnimate(position.maxScrollExtent);
  }

  void scrollDown() {
    scrollWithAnimate(offset + 50);
  }

  void scrollUp() {
    scrollWithAnimate(offset - 50);
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
