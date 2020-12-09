import 'package:flutter/scheduler.dart';
import 'package:flutter_ahlib/src/list/append_indicator.dart';
import 'package:flutter/material.dart';

/// More functions of [ScrollController],
/// including: [scrollWithAnimate], [scrollTop], [scrollBottom], [scrollDown], [scrollUp],
/// [append] (need [attachAppend]), [refresh] (need [attachRefresh]).
@deprecated
class ScrollMoreController extends ScrollController {
  GlobalKey<AppendIndicatorState> _appendIndicatorKey;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  ScrollController Function() _bindControllerFunc;

  /// Register the given [GlobalKey] of [AppendIndicatorState] with this controller.
  void attachAppend(GlobalKey<AppendIndicatorState> s) => _appendIndicatorKey = s;

  /// Register the given [GlobalKey] of [AppendIndicatorState] with this controller.
  void attachRefresh(GlobalKey<RefreshIndicatorState> r) => _refreshIndicatorKey = r;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] with this controller.
  void detachAppend() => _appendIndicatorKey = null;

  /// Unregister the given [GlobalKey] of [RefreshIndicatorState] with this controller.
  void detachRefresh() => _refreshIndicatorKey = null;

  /// Bind the given [ScrollController] with this controller.
  void bind(ScrollController Function() func) => _bindControllerFunc = func;

  /// Unbind the given [ScrollController] with this controller.
  void unbind() => _bindControllerFunc = null;

  /// Get the bind [ScrollController].
  ScrollController get _scrollController => _bindControllerFunc?.call();

  @mustCallSuper
  @override
  void dispose() {
    detachAppend();
    detachRefresh();
    unbind();
    super.dispose();
  }

  // ================================================================================
  // New functions of controller.
  // ================================================================================

  /// Scroll with [Curves.easeOutCirc] with 500ms duration.
  void scrollWithAnimate(double offset, {Curve curve = Curves.easeOutCirc, Duration duration = const Duration(milliseconds: 500)}) {
    animateTo(
      offset,
      curve: curve,
      duration: duration,
    );
  }

  /// Scroll to the top of the list, see [scrollWithAnimate].
  void scrollTop() {
    scrollWithAnimate(0.0);
  }

  /// Scroll to the bottom of the list, see [scrollWithAnimate].
  void scrollBottom() {
    // See https://stackoverflow.com/questions/44141148/how-to-get-full-size-of-a-scrollcontroller.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollWithAnimate(position.maxScrollExtent);
    });
  }

  /// Scroll down from the base position to [scrollOffset] offset, see [scrollWithAnimate].
  void scrollDown({int scrollOffset = 50}) {
    scrollWithAnimate(offset + scrollOffset);
  }

  /// Scroll up from the base position to [scrollOffset] offset, see [scrollWithAnimate].
  void scrollUp({int scrollOffset = 50}) {
    scrollWithAnimate(offset - scrollOffset);
  }

  /// Show the append indicator and run the callback as if it had been started interactively.
  /// See [AppendIndicatorState.show].
  Future<void> append() {
    if (_appendIndicatorKey == null) {
      return Future.value();
    }
    return _appendIndicatorKey.currentState?.show();
  }

  /// Show the refresh indicator and run the callback as if it had been started interactively.
  /// See [RefreshIndicatorState.show].
  Future<void> refresh() {
    if (_refreshIndicatorKey == null) {
      return Future.value();
    }
    return _refreshIndicatorKey.currentState?.show();
  }

  // ================================================================================
  // Override the existed functions and properties.
  // ================================================================================

  /// Register a closure to be called when the object changes.
  @override
  void addListener(VoidCallback listener) {
    var f = _scrollController?.addListener ?? super.addListener;
    f(listener);
  }

  /// Remove a previously registered closure from the list of closures.
  @override
  void removeListener(VoidCallback listener) {
    var f = _scrollController?.removeListener ?? super.removeListener;
    f(listener);
  }

  /// Call all the registered listeners.
  @protected
  @override
  void notifyListeners() {
    var f = _scrollController?.notifyListeners ?? super.notifyListeners;
    return f();
  }

  /// Animates the position from its current value to the given value.
  @override
  Future<void> animateTo(double offset, {@required Duration duration, @required Curve curve}) {
    var f = _scrollController?.animateTo ?? super.animateTo;
    return f(offset, duration: duration, curve: curve);
  }

  /// Jumps the scroll position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  @override
  void jumpTo(double value) {
    var f = _scrollController?.jumpTo ?? super.jumpTo;
    return f(value);
  }

  /// Creates a [ScrollPosition] for use by a [Scrollable] widget.
  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    var f = _scrollController?.createScrollPosition ?? super.createScrollPosition;
    return f(physics, context, oldPosition);
  }

  /// Whether any [ScrollPosition] objects have attached themselves to the
  /// [ScrollController] using the [attach] method.
  @override
  bool get hasClients => _scrollController?.hasClients ?? super.hasClients;

  /// Whether any listeners are currently registered.
  @override
  bool get hasListeners => _scrollController?.hasListeners ?? super.hasListeners;

  /// The initial value to use for [offset].
  @override
  double get initialScrollOffset => _scrollController?.initialScrollOffset ?? super.initialScrollOffset;

  /// Each time a scroll completes, save the current scroll [offset] with
  /// [PageStorage] and restore it if this controller's scrollable is recreated.
  @override
  bool get keepScrollOffset => _scrollController?.keepScrollOffset ?? super.keepScrollOffset;

  /// The current scroll offset of the scrollable widget.
  @override
  double get offset => _scrollController?.offset ?? super.offset;

  /// Returns the attached [ScrollPosition], from which the actual scroll offset
  /// of the [ScrollView] can be obtained.
  @override
  ScrollPosition get position => _scrollController?.position ?? super.position;

  /// The currently attached positions.
  @override
  @protected
  Iterable<ScrollPosition> get positions => _scrollController?.positions ?? super.positions;
}
