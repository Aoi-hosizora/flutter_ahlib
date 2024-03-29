// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

// Note: This file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - NestedScrollView: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/widget/nested_scroll_view.dart
//
// Reference:
// - https://github.com/fluttercandies/extended_nested_scroll_view/blob/master/lib/src/extended_nested_scroll_view_part.dart
// - https://juejin.cn/post/6844903713887223821

/// An extended [NestedScrollView], mainly for [NestedScrollView] with a [TabBarView]
/// or [PageView], which may use multiple [ScrollController]-s.
class ExtendedNestedScrollView extends StatefulWidget {
  const ExtendedNestedScrollView({
    Key? key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    required this.headerSliverBuilder,
    required this.innerControllerCount,
    required this.activeControllerIndex,
    required this.bodyBuilder,
    this.onActiveIndexChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.floatHeaderSlivers = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.onNotification,
  })  : assert(innerControllerCount > 0),
        assert(activeControllerIndex < innerControllerCount),
        super(key: key);

  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final DragStartBehavior dragStartBehavior;
  final bool floatHeaderSlivers;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollBehavior? scrollBehavior;

  /// The inner scroll controller count (or page count). Note that this value should
  /// be larger than zero.
  final int innerControllerCount;

  /// The active inner scroll controller index. Note that only the active controller's
  /// [ScrollPosition] will attach to [ExtendedNestedScrollView] outer nested scroll
  /// controller. Note that this value should be larger than [innerControllerCount].
  final int activeControllerIndex;

  /// The body widget builder. This builder passes all inner scroll controllers as its
  /// second parameter, and it should be used for each page's scroll view. Note that
  /// possibly you need to wrap some pages with [PrimaryScrollController].
  final Widget Function(BuildContext context, List<ScrollController> innerControllers) bodyBuilder;

  /// The callback function to be called when [activeControllerIndex] is changed.
  final void Function(int oldIndex, int newIndex)? onActiveIndexChanged;

  /// The function called when a notification of the appropriate type arrives at this
  /// location in the tree, and it is the same as [NotificationListener.onNotification].
  final bool Function(Notification notification)? onNotification;

  static SliverOverlapAbsorberHandle sliverOverlapAbsorberHandleFor(BuildContext context) {
    final _InheritedNestedScrollView? target = context.dependOnInheritedWidgetOfExactType<_InheritedNestedScrollView>();
    assert(
      target != null,
      'ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor must be called with a context that contains a ExtendedNestedScrollView.',
    );
    return target!.state._absorberHandle;
  }

  // This method is modified by AoiHosizora.
  List<Widget> _buildSlivers(BuildContext context, List<ScrollController> innerControllers, bool bodyIsScrolled) {
    return <Widget>[
      ...headerSliverBuilder(context, bodyIsScrolled),
      SliverFillRemaining(
        child: bodyBuilder(context, innerControllers),
      ),
    ];
  }

  @override
  ExtendedNestedScrollViewState createState() => ExtendedNestedScrollViewState();
}

/// The state of [ExtendedNestedScrollView], can be used to get all inner controllers and outer controller.
class ExtendedNestedScrollViewState extends State<ExtendedNestedScrollView> {
  final SliverOverlapAbsorberHandle _absorberHandle = SliverOverlapAbsorberHandle();

  /// The inner controllers of [ExtendedNestedScrollView].
  List<ScrollController> get innerControllers => _coordinator!._innerControllers; // <<<

  /// The active inner controller of [ExtendedNestedScrollView].
  ScrollController get activeInnerController => _coordinator!._innerControllers[widget.activeControllerIndex];

  /// The outer controller of [ExtendedNestedScrollView].
  ScrollController get outerController => _coordinator!._outerController;

  _ExtendedNestedScrollCoordinator? _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = _ExtendedNestedScrollCoordinator(
      this,
      widget.controller,
      _handleHasScrolledBodyChanged,
      widget.floatHeaderSlivers,
      widget.innerControllerCount,
      widget.activeControllerIndex,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _coordinator!.setParent(widget.controller);
  }

  @override
  void didUpdateWidget(ExtendedNestedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _coordinator!.setParent(widget.controller);
    }
    if (oldWidget.innerControllerCount != widget.innerControllerCount) {
      _coordinator!._setInnerControllerCount(widget.innerControllerCount);
    }
    if (oldWidget.activeControllerIndex != widget.activeControllerIndex) {
      _coordinator!._setActivatedPageIndex(widget.activeControllerIndex);
      widget.onActiveIndexChanged?.call(oldWidget.activeControllerIndex, widget.activeControllerIndex);
    }
  }

  @override
  void dispose() {
    _coordinator!.dispose();
    _coordinator = null;
    super.dispose();
  }

  bool? _lastHasScrolledBody;

  void _handleHasScrolledBodyChanged() {
    if (!mounted) return;
    final bool newHasScrolledBody = _coordinator!.hasScrolledBody;
    if (_lastHasScrolledBody != newHasScrolledBody) {
      setState(() {
        // _coordinator.hasScrolledBody changed (we use it in the build method)
        // (We record _lastHasScrolledBody in the build() method, rather than in
        // this setState call, because the build() method may be called more
        // often than just from here, and we want to only call setState when the
        // new value is different than the last built value.)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPhysics _scrollPhysics = widget.physics?.applyTo(const ClampingScrollPhysics()) ?? //
        widget.scrollBehavior?.getScrollPhysics(context).applyTo(const ClampingScrollPhysics()) ??
        const ClampingScrollPhysics();

    return NotificationListener(
      onNotification: widget.onNotification,
      child: _InheritedNestedScrollView(
        state: this,
        child: Builder(
          builder: (BuildContext context) {
            _lastHasScrolledBody = _coordinator!.hasScrolledBody;
            return _NestedScrollViewCustomScrollView(
              dragStartBehavior: widget.dragStartBehavior,
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              physics: _scrollPhysics,
              scrollBehavior: widget.scrollBehavior ?? ScrollConfiguration.of(context).copyWith(scrollbars: false),
              controller: _coordinator!._outerController,
              slivers: widget._buildSlivers(
                context,
                _coordinator!._innerControllers, // <<<
                _lastHasScrolledBody!,
              ),
              handle: _absorberHandle,
              clipBehavior: widget.clipBehavior,
              restorationId: widget.restorationId,
            );
          },
        ),
      ),
    );
  }
}

class _NestedScrollViewCustomScrollView extends CustomScrollView {
  const _NestedScrollViewCustomScrollView({
    required Axis scrollDirection,
    required bool reverse,
    required ScrollPhysics physics,
    required ScrollBehavior scrollBehavior,
    required ScrollController controller,
    required List<Widget> slivers,
    required this.handle,
    required Clip clipBehavior,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    String? restorationId,
  }) : super(
          scrollDirection: scrollDirection,
          reverse: reverse,
          physics: physics,
          scrollBehavior: scrollBehavior,
          controller: controller,
          slivers: slivers,
          dragStartBehavior: dragStartBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  final SliverOverlapAbsorberHandle handle;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    assert(!shrinkWrap);
    return NestedScrollViewViewport(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      handle: handle,
      clipBehavior: clipBehavior,
    );
  }
}

class _InheritedNestedScrollView extends InheritedWidget {
  const _InheritedNestedScrollView({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final ExtendedNestedScrollViewState state;

  @override
  bool updateShouldNotify(_InheritedNestedScrollView old) => state != old.state;
}

class _NestedScrollMetrics extends FixedScrollMetrics {
  _NestedScrollMetrics({
    required double? minScrollExtent,
    required double? maxScrollExtent,
    required double? pixels,
    required double? viewportDimension,
    required AxisDirection axisDirection,
    required this.minRange,
    required this.maxRange,
    required this.correctionOffset,
  }) : super(
          minScrollExtent: minScrollExtent,
          maxScrollExtent: maxScrollExtent,
          pixels: pixels,
          viewportDimension: viewportDimension,
          axisDirection: axisDirection,
        );

  @override
  _NestedScrollMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? minRange,
    double? maxRange,
    double? correctionOffset,
  }) {
    return _NestedScrollMetrics(
      minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      minRange: minRange ?? this.minRange,
      maxRange: maxRange ?? this.maxRange,
      correctionOffset: correctionOffset ?? this.correctionOffset,
    );
  }

  final double minRange;

  final double maxRange;

  final double correctionOffset;
}

typedef _NestedScrollActivityGetter = ScrollActivity Function(_NestedScrollPosition position);

class _ExtendedNestedScrollCoordinator implements ScrollActivityDelegate, ScrollHoldController {
  // This constructor is modified by AoiHosizora.
  _ExtendedNestedScrollCoordinator(
    this._state,
    this._parent,
    this._onHasScrolledBodyChanged,
    this._floatHeaderSlivers,
    this._innerControllerCount,
    this._activatedPageIndex,
  ) {
    final double initialScrollOffset = _parent?.initialScrollOffset ?? 0.0;
    _outerController = _NestedScrollController(
      this,
      initialScrollOffset: initialScrollOffset,
      debugLabel: 'outer',
    );
    _innerControllers = List.generate(
      _innerControllerCount,
      (_) => _NestedScrollController(
        this,
        debugLabel: 'inner',
      ),
    );
  }

  final ExtendedNestedScrollViewState _state;
  ScrollController? _parent;
  final VoidCallback _onHasScrolledBodyChanged;
  final bool _floatHeaderSlivers;

  int _innerControllerCount;
  int _activatedPageIndex;
  late _NestedScrollController _outerController;
  late List<_NestedScrollController> _innerControllers;

  _NestedScrollPosition? get _outerPosition {
    if (!_outerController.hasClients) return null;
    return _outerController.nestedPositions.single;
  }

  // This property is modified by AoiHosizora.
  Iterable<_NestedScrollPosition> get _innerPositions {
    assert(_innerControllerCount > 0);
    assert(_activatedPageIndex < _innerControllerCount);
    return _innerControllers[_activatedPageIndex].nestedPositions;
  }

  bool get canScrollBody {
    final _NestedScrollPosition? outer = _outerPosition;
    if (outer == null) return true;
    return outer.haveDimensions && outer.extentAfter == 0.0;
  }

  bool get hasScrolledBody {
    for (final _NestedScrollPosition position in _innerPositions) {
      if (!position.hasContentDimensions || !position.hasPixels) {
        // It's possible that NestedScrollView built twice before layout phase
        // in the same frame. This can happen when the FocusManager schedules a microTask
        // that marks NestedScrollView dirty during the warm up frame.
        // https://github.com/flutter/flutter/pull/75308
        continue;
      } else if (position.pixels > position.minScrollExtent) {
        return true;
      }
    }
    return false;
  }

  void updateShadow() {
    _onHasScrolledBodyChanged();
  }

  ScrollDirection get userScrollDirection => _userScrollDirection;
  ScrollDirection _userScrollDirection = ScrollDirection.idle;

  void updateUserScrollDirection(ScrollDirection value) {
    if (userScrollDirection == value) return;
    _userScrollDirection = value;
    _outerPosition!.didUpdateScrollDirection(value);
    for (final _NestedScrollPosition position in _innerPositions) {
      position.didUpdateScrollDirection(value);
    }
  }

  ScrollDragController? _currentDrag;

  void beginActivity(ScrollActivity newOuterActivity, _NestedScrollActivityGetter innerActivityGetter) {
    _outerPosition!.beginActivity(newOuterActivity);
    bool scrolling = newOuterActivity.isScrolling;
    for (final _NestedScrollPosition position in _innerPositions) {
      final ScrollActivity newInnerActivity = innerActivityGetter(position);
      position.beginActivity(newInnerActivity);
      scrolling = scrolling && newInnerActivity.isScrolling;
    }
    _currentDrag?.dispose();
    _currentDrag = null;
    if (!scrolling) updateUserScrollDirection(ScrollDirection.idle);
  }

  @override
  AxisDirection get axisDirection => _outerPosition!.axisDirection;

  static IdleScrollActivity _createIdleScrollActivity(_NestedScrollPosition position) {
    return IdleScrollActivity(position);
  }

  @override
  void goIdle() {
    beginActivity(
      _createIdleScrollActivity(_outerPosition!),
      _createIdleScrollActivity,
    );
  }

  @override
  void goBallistic(double velocity) {
    beginActivity(
      createOuterBallisticScrollActivity(velocity),
      (_NestedScrollPosition position) {
        return createInnerBallisticScrollActivity(
          position,
          velocity,
        );
      },
    );
  }

  ScrollActivity createOuterBallisticScrollActivity(double velocity) {
    // This function creates a ballistic scroll for the outer scrollable.
    //
    // It assumes that the outer scrollable can't be overscrolled, and sets up a
    // ballistic scroll over the combined space of the innerPositions and the
    // outerPosition.

    // First we must pick a representative inner position that we will care
    // about. This is somewhat arbitrary. Ideally we'd pick the one that is "in
    // the center" but there isn't currently a good way to do that so we
    // arbitrarily pick the one that is the furthest away from the infinity we
    // are heading towards.
    _NestedScrollPosition? innerPosition;
    if (velocity != 0.0) {
      for (final _NestedScrollPosition position in _innerPositions) {
        if (innerPosition != null) {
          if (velocity > 0.0) {
            if (innerPosition.pixels < position.pixels) continue;
          } else {
            assert(velocity < 0.0);
            if (innerPosition.pixels > position.pixels) continue;
          }
        }
        innerPosition = position;
      }
    }

    if (innerPosition == null) {
      // It's either just us or a velocity=0 situation.
      return _outerPosition!.createBallisticScrollActivity(
        _outerPosition!.physics.createBallisticSimulation(
          _outerPosition!,
          velocity,
        ),
        mode: _NestedBallisticScrollActivityMode.independent,
      );
    }

    final _NestedScrollMetrics metrics = _getMetrics(innerPosition, velocity);

    return _outerPosition!.createBallisticScrollActivity(
      _outerPosition!.physics.createBallisticSimulation(metrics, velocity),
      mode: _NestedBallisticScrollActivityMode.outer,
      metrics: metrics,
    );
  }

  @protected
  ScrollActivity createInnerBallisticScrollActivity(_NestedScrollPosition position, double velocity) {
    return position.createBallisticScrollActivity(
      position.physics.createBallisticSimulation(
        _getMetrics(position, velocity),
        velocity,
      ),
      mode: _NestedBallisticScrollActivityMode.inner,
    );
  }

  _NestedScrollMetrics _getMetrics(_NestedScrollPosition innerPosition, double velocity) {
    double pixels, minRange, maxRange, correctionOffset;
    double extra = 0.0;
    if (innerPosition.pixels == innerPosition.minScrollExtent) {
      pixels = _outerPosition!.pixels.clamp(
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
      minRange = _outerPosition!.minScrollExtent;
      maxRange = _outerPosition!.maxScrollExtent;
      assert(minRange <= maxRange);
      correctionOffset = 0.0;
    } else {
      assert(innerPosition.pixels != innerPosition.minScrollExtent);
      if (innerPosition.pixels < innerPosition.minScrollExtent) {
        pixels = innerPosition.pixels - innerPosition.minScrollExtent + _outerPosition!.minScrollExtent;
      } else {
        assert(innerPosition.pixels > innerPosition.minScrollExtent);
        pixels = innerPosition.pixels - innerPosition.minScrollExtent + _outerPosition!.maxScrollExtent;
      }
      if ((velocity > 0.0) && (innerPosition.pixels > innerPosition.minScrollExtent)) {
        // This handles going forward (fling up) and inner list is scrolled past
        // zero. We want to grab the extra pixels immediately to shrink.
        extra = _outerPosition!.maxScrollExtent - _outerPosition!.pixels;
        assert(extra >= 0.0);
        minRange = pixels;
        maxRange = pixels + extra;
        assert(minRange <= maxRange);
        correctionOffset = _outerPosition!.pixels - pixels;
      } else if ((velocity < 0.0) && (innerPosition.pixels < innerPosition.minScrollExtent)) {
        // This handles going backward (fling down) and inner list is
        // underscrolled. We want to grab the extra pixels immediately to grow.
        extra = _outerPosition!.pixels - _outerPosition!.minScrollExtent;
        assert(extra >= 0.0);
        minRange = pixels - extra;
        maxRange = pixels;
        assert(minRange <= maxRange);
        correctionOffset = _outerPosition!.pixels - pixels;
      } else {
        // This handles going forward (fling up) and inner list is
        // underscrolled, OR, going backward (fling down) and inner list is
        // scrolled past zero. We want to skip the pixels we don't need to grow
        // or shrink over.
        if (velocity > 0.0) {
          // shrinking
          extra = _outerPosition!.minScrollExtent - _outerPosition!.pixels;
        } else if (velocity < 0.0) {
          // growing
          extra = _outerPosition!.pixels - (_outerPosition!.maxScrollExtent - _outerPosition!.minScrollExtent);
        }
        assert(extra <= 0.0);
        minRange = _outerPosition!.minScrollExtent;
        maxRange = _outerPosition!.maxScrollExtent + extra;
        assert(minRange <= maxRange);
        correctionOffset = 0.0;
      }
    }
    return _NestedScrollMetrics(
      minScrollExtent: _outerPosition!.minScrollExtent,
      maxScrollExtent: _outerPosition!.maxScrollExtent + innerPosition.maxScrollExtent - innerPosition.minScrollExtent + extra,
      pixels: pixels,
      viewportDimension: _outerPosition!.viewportDimension,
      axisDirection: _outerPosition!.axisDirection,
      minRange: minRange,
      maxRange: maxRange,
      correctionOffset: correctionOffset,
    );
  }

  double unnestOffset(double value, _NestedScrollPosition source) {
    if (source == _outerPosition) {
      return value.clamp(
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
    }
    if (value < source.minScrollExtent) return value - source.minScrollExtent + _outerPosition!.minScrollExtent;
    return value - source.minScrollExtent + _outerPosition!.maxScrollExtent;
  }

  double nestOffset(double value, _NestedScrollPosition target) {
    if (target == _outerPosition) {
      return value.clamp(
        _outerPosition!.minScrollExtent,
        _outerPosition!.maxScrollExtent,
      );
    }
    if (value < _outerPosition!.minScrollExtent) return value - _outerPosition!.minScrollExtent + target.minScrollExtent;
    if (value > _outerPosition!.maxScrollExtent) return value - _outerPosition!.maxScrollExtent + target.minScrollExtent;
    return target.minScrollExtent;
  }

  void updateCanDrag() {
    if (!_outerPosition!.haveDimensions) return;
    double maxInnerExtent = 0.0;
    for (final _NestedScrollPosition position in _innerPositions) {
      if (!position.haveDimensions) return;
      maxInnerExtent = math.max(
        maxInnerExtent,
        position.maxScrollExtent - position.minScrollExtent,
      );
    }
    _outerPosition!.updateCanDrag(maxInnerExtent);
  }

  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) async {
    final DrivenScrollActivity outerActivity = _outerPosition!.createDrivenScrollActivity(
      nestOffset(to, _outerPosition!),
      duration,
      curve,
    );
    final List<Future<void>> resultFutures = <Future<void>>[outerActivity.done];
    beginActivity(
      outerActivity,
      (_NestedScrollPosition position) {
        final DrivenScrollActivity innerActivity = position.createDrivenScrollActivity(
          nestOffset(to, position),
          duration,
          curve,
        );
        resultFutures.add(innerActivity.done);
        return innerActivity;
      },
    );
    await Future.wait<void>(resultFutures);
  }

  void jumpTo(double to) {
    goIdle();
    _outerPosition!.localJumpTo(nestOffset(to, _outerPosition!));
    for (final _NestedScrollPosition position in _innerPositions) {
      position.localJumpTo(nestOffset(to, position));
    }
    goBallistic(0.0);
  }

  void pointerScroll(double delta) {
    assert(delta != 0.0);

    goIdle();
    updateUserScrollDirection(
      delta < 0.0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );

    // Set the isScrollingNotifier. Even if only one position actually receives
    // the delta, the NestedScrollView's intention is to treat multiple
    // ScrollPositions as one.
    _outerPosition!.isScrollingNotifier.value = true;
    for (final _NestedScrollPosition position in _innerPositions) {
      position.isScrollingNotifier.value = true;
    }

    if (_innerPositions.isEmpty) {
      // Does not enter overscroll.
      _outerPosition!.applyClampedPointerSignalUpdate(delta);
    } else if (delta > 0.0) {
      // Dragging "up" - delta is positive
      // Prioritize getting rid of any inner overscroll, and then the outer
      // view, so that the app bar will scroll out of the way asap.
      double outerDelta = delta;
      for (final _NestedScrollPosition position in _innerPositions) {
        if (position.pixels < 0.0) {
          // This inner position is in overscroll.
          final double potentialOuterDelta = position.applyClampedPointerSignalUpdate(delta);
          // In case there are multiple positions in varying states of
          // overscroll, the first to 'reach' the outer view above takes
          // precedence.
          outerDelta = math.max(outerDelta, potentialOuterDelta);
        }
      }
      if (outerDelta != 0.0) {
        final double innerDelta = _outerPosition!.applyClampedPointerSignalUpdate(
          outerDelta,
        );
        if (innerDelta != 0.0) {
          for (final _NestedScrollPosition position in _innerPositions) {
            position.applyClampedPointerSignalUpdate(innerDelta);
          }
        }
      }
    } else {
      // Dragging "down" - delta is negative
      double innerDelta = delta;
      // Apply delta to the outer header first if it is configured to float.
      if (_floatHeaderSlivers) innerDelta = _outerPosition!.applyClampedPointerSignalUpdate(delta);

      if (innerDelta != 0.0) {
        // Apply the innerDelta, if we have not floated in the outer scrollable,
        // any leftover delta after this will be passed on to the outer
        // scrollable by the outerDelta.
        double outerDelta = 0.0; // it will go negative if it changes
        for (final _NestedScrollPosition position in _innerPositions) {
          final double overscroll = position.applyClampedPointerSignalUpdate(innerDelta);
          outerDelta = math.min(outerDelta, overscroll);
        }
        if (outerDelta != 0.0) _outerPosition!.applyClampedPointerSignalUpdate(outerDelta);
      }
    }
    goBallistic(0.0);
  }

  @override
  double setPixels(double newPixels) {
    assert(false);
    return 0.0;
  }

  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    beginActivity(
      HoldScrollActivity(
        delegate: _outerPosition!,
        onHoldCanceled: holdCancelCallback,
      ),
      (_NestedScrollPosition position) => HoldScrollActivity(delegate: position),
    );
    return this;
  }

  @override
  void cancel() {
    goBallistic(0.0);
  }

  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    final ScrollDragController drag = ScrollDragController(
      delegate: this,
      details: details,
      onDragCanceled: dragCancelCallback,
    );
    beginActivity(
      DragScrollActivity(_outerPosition!, drag),
      (_NestedScrollPosition position) => DragScrollActivity(position, drag),
    );
    assert(_currentDrag == null);
    _currentDrag = drag;
    return drag;
  }

  @override
  void applyUserOffset(double delta) {
    updateUserScrollDirection(
      delta > 0.0 ? ScrollDirection.forward : ScrollDirection.reverse,
    );
    assert(delta != 0.0);
    if (_innerPositions.isEmpty) {
      _outerPosition!.applyFullDragUpdate(delta);
    } else if (delta < 0.0) {
      // Dragging "up"
      // Prioritize getting rid of any inner overscroll, and then the outer
      // view, so that the app bar will scroll out of the way asap.
      double outerDelta = delta;
      for (final _NestedScrollPosition position in _innerPositions) {
        if (position.pixels < 0.0) {
          // This inner position is in overscroll.
          final double potentialOuterDelta = position.applyClampedDragUpdate(delta);
          // In case there are multiple positions in varying states of
          // overscroll, the first to 'reach' the outer view above takes
          // precedence.
          outerDelta = math.max(outerDelta, potentialOuterDelta);
        }
      }
      if (outerDelta != 0.0) {
        final double innerDelta = _outerPosition!.applyClampedDragUpdate(
          outerDelta,
        );
        if (innerDelta != 0.0) {
          for (final _NestedScrollPosition position in _innerPositions) {
            position.applyFullDragUpdate(innerDelta);
          }
        }
      }
    } else {
      // Dragging "down" - delta is positive
      double innerDelta = delta;
      // Apply delta to the outer header first if it is configured to float.
      if (_floatHeaderSlivers) innerDelta = _outerPosition!.applyClampedDragUpdate(delta);

      if (innerDelta != 0.0) {
        // Apply the innerDelta, if we have not floated in the outer scrollable,
        // any leftover delta after this will be passed on to the outer
        // scrollable by the outerDelta.
        double outerDelta = 0.0; // it will go positive if it changes
        final List<double> overscrolls = <double>[];
        final List<_NestedScrollPosition> innerPositions = _innerPositions.toList();
        for (final _NestedScrollPosition position in innerPositions) {
          final double overscroll = position.applyClampedDragUpdate(innerDelta);
          outerDelta = math.max(outerDelta, overscroll);
          overscrolls.add(overscroll);
        }
        if (outerDelta != 0.0) outerDelta -= _outerPosition!.applyClampedDragUpdate(outerDelta);

        // Now deal with any overscroll
        for (int i = 0; i < innerPositions.length; ++i) {
          final double remainingDelta = overscrolls[i] - outerDelta;
          if (remainingDelta > 0.0) innerPositions[i].applyFullDragUpdate(remainingDelta);
        }
      }
    }
  }

  void setParent(ScrollController? value) {
    _parent = value;
    updateParent();
  }

  void updateParent() {
    _outerPosition?.setParent(
      _parent ?? PrimaryScrollController.of(_state.context),
    );
  }

  // This method is added by AoiHosizora.
  void _setInnerControllerCount(int value) {
    _innerControllerCount = value;
    _updateInnerControllers();
  }

  // This method is added by AoiHosizora.
  void _updateInnerControllers() {
    if (_innerControllers.length > _innerControllerCount) {
      _innerControllers.removeRange(_innerControllerCount, _innerControllers.length);
    } else if (_innerControllers.length < _innerControllerCount) {
      _innerControllers.addAll(
        List.generate(
          _innerControllerCount - _innerControllers.length,
          (_) => _NestedScrollController(
            this,
            debugLabel: 'inner',
          ),
        ),
      );
    }
  }

  // This method is added by AoiHosizora.
  void _setActivatedPageIndex(int value) {
    _activatedPageIndex = value;
  }

  @mustCallSuper
  void dispose() {
    _currentDrag?.dispose();
    _currentDrag = null;
    _outerController.dispose();
    for (final controller in _innerControllers) {
      controller.dispose();
    }
  }

  @override
  String toString() => '${objectRuntimeType(this, '_ExtendedNestedScrollCoordinator')}(outer=$_outerController; inners=$_innerControllers)';
}

class _NestedScrollController extends ScrollController {
  _NestedScrollController(
    this.coordinator, {
    double initialScrollOffset = 0.0,
    String? debugLabel,
  }) : super(initialScrollOffset: initialScrollOffset, debugLabel: debugLabel);

  final _ExtendedNestedScrollCoordinator coordinator;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _NestedScrollPosition(
      coordinator: coordinator,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  void attach(ScrollPosition position) {
    assert(position is _NestedScrollPosition);
    super.attach(position);
    coordinator.updateParent();
    coordinator.updateCanDrag();
    position.addListener(_scheduleUpdateShadow);
    _scheduleUpdateShadow();
  }

  @override
  void detach(ScrollPosition position) {
    assert(position is _NestedScrollPosition);
    (position as _NestedScrollPosition).setParent(null);
    position.removeListener(_scheduleUpdateShadow);
    super.detach(position);
    _scheduleUpdateShadow();
  }

  void _scheduleUpdateShadow() {
    // We do this asynchronously for attach() so that the new position has had
    // time to be initialized, and we do it asynchronously for detach() and from
    // the position change notifications because those happen synchronously
    // during a frame, at a time where it's too late to call setState. Since the
    // result is usually animated, the lag incurred is no big deal.
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (Duration timeStamp) {
        coordinator.updateShadow();
      },
    );
  }

  Iterable<_NestedScrollPosition> get nestedPositions {
    return Iterable.castFrom<ScrollPosition, _NestedScrollPosition>(positions);
  }
}

class _NestedScrollPosition extends ScrollPosition implements ScrollActivityDelegate {
  _NestedScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    double initialPixels = 0.0,
    ScrollPosition? oldPosition,
    String? debugLabel,
    required this.coordinator,
  }) : super(
          physics: physics,
          context: context,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        ) {
    if (!hasPixels) correctPixels(initialPixels);
    if (activity == null) goIdle();
    assert(activity != null);
    saveScrollOffset(); // in case we didn't restore but could, so that we don't restore it later
  }

  final _ExtendedNestedScrollCoordinator coordinator;

  TickerProvider get vsync => context.vsync;

  ScrollController? _parent;

  void setParent(ScrollController? value) {
    _parent?.detach(this);
    _parent = value;
    _parent?.attach(this);
  }

  @override
  AxisDirection get axisDirection => context.axisDirection;

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    activity!.updateDelegate(this);
  }

  @override
  void restoreScrollOffset() {
    if (coordinator.canScrollBody) super.restoreScrollOffset();
  }

  // Returns the amount of delta that was not used.
  //
  // Positive delta means going down (exposing stuff above), negative delta
  // going up (exposing stuff below).
  double applyClampedDragUpdate(double delta) {
    assert(delta != 0.0);
    // If we are going towards the maxScrollExtent (negative scroll offset),
    // then the furthest we can be in the minScrollExtent direction is negative
    // infinity. For example, if we are already overscrolled, then scrolling to
    // reduce the overscroll should not disallow the overscroll.
    //
    // If we are going towards the minScrollExtent (positive scroll offset),
    // then the furthest we can be in the minScrollExtent direction is wherever
    // we are now, if we are already overscrolled (in which case pixels is less
    // than the minScrollExtent), or the minScrollExtent if we are not.
    //
    // In other words, we cannot, via applyClampedDragUpdate, _enter_ an
    // overscroll situation.
    //
    // An overscroll situation might be nonetheless entered via several means.
    // One is if the physics allow it, via applyFullDragUpdate (see below). An
    // overscroll situation can also be forced, e.g. if the scroll position is
    // artificially set using the scroll controller.
    final double min = delta < 0.0 ? -double.infinity : math.min(minScrollExtent, pixels);
    // The logic for max is equivalent but on the other side.
    final double max = delta > 0.0
        ? double.infinity
        // If pixels < 0.0, then we are currently in overscroll. The max should be
        // 0.0, representing the end of the overscrolled portion.
        : pixels < 0.0
            ? 0.0
            : math.max(maxScrollExtent, pixels);
    final double oldPixels = pixels;
    final double newPixels = (pixels - delta).clamp(min, max);
    final double clampedDelta = newPixels - pixels;
    if (clampedDelta == 0.0) return delta;
    final double overscroll = physics.applyBoundaryConditions(this, newPixels);
    final double actualNewPixels = newPixels - overscroll;
    final double offset = actualNewPixels - oldPixels;
    if (offset != 0.0) {
      forcePixels(actualNewPixels);
      didUpdateScrollPositionBy(offset);
    }
    return delta + offset;
  }

  // Returns the overscroll.
  double applyFullDragUpdate(double delta) {
    assert(delta != 0.0);
    final double oldPixels = pixels;
    // Apply friction:
    final double newPixels = pixels -
        physics.applyPhysicsToUserOffset(
          this,
          delta,
        );
    if (oldPixels == newPixels) return 0.0; // delta must have been so small we dropped it during floating point addition
    // Check for overscroll:
    final double overscroll = physics.applyBoundaryConditions(this, newPixels);
    final double actualNewPixels = newPixels - overscroll;
    if (actualNewPixels != oldPixels) {
      forcePixels(actualNewPixels);
      didUpdateScrollPositionBy(actualNewPixels - oldPixels);
    }
    if (overscroll != 0.0) {
      didOverscrollBy(overscroll);
      return overscroll;
    }
    return 0.0;
  }

  // Returns the amount of delta that was not used.
  //
  // Negative delta represents a forward ScrollDirection, while the positive
  // would be a reverse ScrollDirection.
  //
  // The method doesn't take into account the effects of [ScrollPhysics].
  double applyClampedPointerSignalUpdate(double delta) {
    assert(delta != 0.0);

    final double min = delta > 0.0 ? -double.infinity : math.min(minScrollExtent, pixels);
    // The logic for max is equivalent but on the other side.
    final double max = delta < 0.0 ? double.infinity : math.max(maxScrollExtent, pixels);
    final double newPixels = (pixels + delta).clamp(min, max);
    final double clampedDelta = newPixels - pixels;
    if (clampedDelta == 0.0) return delta;
    forcePixels(newPixels);
    didUpdateScrollPositionBy(clampedDelta);
    return delta - clampedDelta;
  }

  @override
  ScrollDirection get userScrollDirection => coordinator.userScrollDirection;

  DrivenScrollActivity createDrivenScrollActivity(double to, Duration duration, Curve curve) {
    return DrivenScrollActivity(
      this,
      from: pixels,
      to: to,
      duration: duration,
      curve: curve,
      vsync: vsync,
    );
  }

  @override
  double applyUserOffset(double delta) {
    assert(false);
    return 0.0;
  }

  // This is called by activities when they finish their work.
  @override
  void goIdle() {
    beginActivity(IdleScrollActivity(this));
  }

  // This is called by activities when they finish their work and want to go
  // ballistic.
  @override
  void goBallistic(double velocity) {
    Simulation? simulation;
    if (velocity != 0.0 || outOfRange) simulation = physics.createBallisticSimulation(this, velocity);
    beginActivity(createBallisticScrollActivity(
      simulation,
      mode: _NestedBallisticScrollActivityMode.independent,
    ));
  }

  ScrollActivity createBallisticScrollActivity(
    Simulation? simulation, {
    required _NestedBallisticScrollActivityMode mode,
    _NestedScrollMetrics? metrics,
  }) {
    if (simulation == null) return IdleScrollActivity(this);
    switch (mode) {
      case _NestedBallisticScrollActivityMode.outer:
        assert(metrics != null);
        if (metrics!.minRange == metrics.maxRange) return IdleScrollActivity(this);
        return _NestedOuterBallisticScrollActivity(
          coordinator,
          this,
          metrics,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.inner:
        return _NestedInnerBallisticScrollActivity(
          coordinator,
          this,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.independent:
        return BallisticScrollActivity(this, simulation, context.vsync);
    }
  }

  @override
  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) {
    return coordinator.animateTo(
      coordinator.unnestOffset(to, this),
      duration: duration,
      curve: curve,
    );
  }

  @override
  void jumpTo(double value) {
    return coordinator.jumpTo(coordinator.unnestOffset(value, this));
  }

  @override
  void pointerScroll(double delta) {
    return coordinator.pointerScroll(delta);
  }

  @override
  void jumpToWithoutSettling(double value) {
    assert(false);
  }

  void localJumpTo(double value) {
    if (pixels != value) {
      final double oldPixels = pixels;
      forcePixels(value);
      didStartScroll();
      didUpdateScrollPositionBy(pixels - oldPixels);
      didEndScroll();
    }
  }

  @override
  void applyNewDimensions() {
    super.applyNewDimensions();
    coordinator.updateCanDrag();
  }

  void updateCanDrag(double totalExtent) {
    context.setCanDrag(totalExtent > (viewportDimension - maxScrollExtent) || minScrollExtent != maxScrollExtent);
  }

  @override
  ScrollHoldController hold(VoidCallback holdCancelCallback) {
    return coordinator.hold(holdCancelCallback);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    return coordinator.drag(details, dragCancelCallback);
  }
}

enum _NestedBallisticScrollActivityMode { outer, inner, independent }

class _NestedInnerBallisticScrollActivity extends BallisticScrollActivity {
  _NestedInnerBallisticScrollActivity(
    this.coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(position, simulation, vsync);

  final _ExtendedNestedScrollCoordinator coordinator;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  bool applyMoveTo(double value) {
    return super.applyMoveTo(coordinator.nestOffset(value, delegate));
  }
}

class _NestedOuterBallisticScrollActivity extends BallisticScrollActivity {
  _NestedOuterBallisticScrollActivity(
    this.coordinator,
    _NestedScrollPosition position,
    this.metrics,
    Simulation simulation,
    TickerProvider vsync,
  )   : assert(metrics.minRange != metrics.maxRange),
        assert(metrics.maxRange > metrics.minRange),
        super(position, simulation, vsync);

  final _ExtendedNestedScrollCoordinator coordinator;
  final _NestedScrollMetrics metrics;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(
      coordinator.createOuterBallisticScrollActivity(velocity),
    );
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(
      coordinator.createOuterBallisticScrollActivity(velocity),
    );
  }

  @override
  bool applyMoveTo(double value) {
    bool done = false;
    if (velocity > 0.0) {
      if (value < metrics.minRange) return true;
      if (value > metrics.maxRange) {
        value = metrics.maxRange;
        done = true;
      }
    } else if (velocity < 0.0) {
      if (value > metrics.maxRange) return true;
      if (value < metrics.minRange) {
        value = metrics.minRange;
        done = true;
      }
    } else {
      value = value.clamp(metrics.minRange, metrics.maxRange);
      done = true;
    }
    final bool result = super.applyMoveTo(value + metrics.correctionOffset);
    assert(result); // since we tried to pass an in-range value, it shouldn't ever overflow
    return !done;
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, '_NestedOuterBallisticScrollActivity')}(${metrics.minRange} .. ${metrics.maxRange}; correcting by ${metrics.correctionOffset})';
  }
}
