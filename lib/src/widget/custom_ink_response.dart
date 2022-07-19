// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Note: The file is based on Flutter's source code, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - InkResponse: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/ink_well.dart

/// A custom [InkWell] with [getRadius], [getRect] for ink feature.
class CustomInkWell extends CustomInkResponse {
  const CustomInkWell({
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapDownCallback? onTapDown,
    GestureTapCallback? onTapCancel,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    MaterialStateProperty<Color?>? overlayColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    Key? key,
    Duration? Function(HighlightType type)? highlightFadeDuration,
    double? Function(RenderBox referenceBox)? getRadius,
    Rect? Function(RenderBox referenceBox)? getRect,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          mouseCursor: mouseCursor,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: borderRadius,
          customBorder: customBorder,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          overlayColor: overlayColor,
          splashColor: splashColor,
          splashFactory: splashFactory,
          enableFeedback: enableFeedback,
          excludeFromSemantics: excludeFromSemantics,
          onFocusChange: onFocusChange,
          autofocus: autofocus,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          highlightFadeDuration: highlightFadeDuration,
          getRadius: getRadius,
          getRect: getRect,
        );
}

/// A custom [InkResponse] with [getRadius], [getRect] for ink feature.
///
/// Note that you can set [containedInkWell] to true and set [highlightShape]
/// to [BoxShape.rectangle] to get a custom [InkWell], or said, [CustomInkWell].
class CustomInkResponse extends StatefulWidget {
  const CustomInkResponse({
    Key? key,
    this.child,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.containedInkWell = false,
    this.highlightShape = BoxShape.circle,
    this.borderRadius,
    this.customBorder,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.onFocusChange,
    this.autofocus = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.highlightFadeDuration, // <<<
    this.getRadius, // <<<
    this.getRect, // <<<
  }) : super(key: key);

  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCallback? onTapCancel;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final MouseCursor? mouseCursor;
  final bool containedInkWell;
  final BoxShape highlightShape;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool canRequestFocus;

  /// The fade duration function for [InkHighlight] with given [HighlightType].
  final Duration? Function(HighlightType type)? highlightFadeDuration;

  /// The target radius getter function for ink highlight and ink feature with
  /// [RenderBox].
  final double? Function(RenderBox referenceBox)? getRadius;

  /// The clip rect getter function for ink highlight and ink feature with
  /// [RenderBox].
  final Rect? Function(RenderBox referenceBox)? getRect;

  @override
  State<CustomInkResponse> createState() => _CustomInkResponseState();
}

abstract class _ParentInkResponseState {
  void markChildInkResponsePressed(_ParentInkResponseState childState, bool value);
}

class _ParentInkResponseProvider extends InheritedWidget {
  const _ParentInkResponseProvider({
    required this.state,
    required Widget child,
  }) : super(child: child);

  final _ParentInkResponseState state;

  @override
  bool updateShouldNotify(_ParentInkResponseProvider oldWidget) => state != oldWidget.state;

  static _ParentInkResponseState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ParentInkResponseProvider>()?.state;
  }
}

/// Used to index the allocated highlights for the different types of highlights
/// in [_CustomInkResponseState].
enum HighlightType {
  pressed,
  hover,
  focus,
}

class _CustomInkResponseState extends State<CustomInkResponse> with AutomaticKeepAliveClientMixin<CustomInkResponse> implements _ParentInkResponseState {
  late final _ParentInkResponseState? parentState = _ParentInkResponseProvider.of(context);

  Set<InteractiveInkFeature>? _splashes;
  InteractiveInkFeature? _currentSplash;
  bool _hovering = false;
  final Map<HighlightType, InkHighlight?> _highlights = <HighlightType, InkHighlight?>{};
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _simulateTap),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: _simulateTap),
  };

  bool get highlightsExist => _highlights.values.where((InkHighlight? highlight) => highlight != null).isNotEmpty;

  final ObserverList<_ParentInkResponseState> _activeChildren = ObserverList<_ParentInkResponseState>();

  @override
  void markChildInkResponsePressed(_ParentInkResponseState childState, bool value) {
    final bool lastAnyPressed = _anyChildInkResponsePressed;
    if (value) {
      _activeChildren.add(childState);
    } else {
      _activeChildren.remove(childState);
    }
    final bool nowAnyPressed = _anyChildInkResponsePressed;
    if (nowAnyPressed != lastAnyPressed) {
      parentState?.markChildInkResponsePressed(this, nowAnyPressed);
    }
  }

  bool get _anyChildInkResponsePressed => _activeChildren.isNotEmpty;

  void _simulateTap([Intent? intent]) {
    _startSplash(context: context);
    _handleTap();
  }

  void _simulateLongPress() {
    _startSplash(context: context);
    _handleLongPress();
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_handleFocusHighlightModeChange);
  }

  @override
  void didUpdateWidget(covariant CustomInkResponse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetEnabled(widget) != _isWidgetEnabled(oldWidget)) {
      if (enabled) {
        // Don't call widget.onHover because many widgets, including the button
        // widgets, apply setState to an ancestor context from onHover.
        updateHighlight(HighlightType.hover, value: _hovering, callOnHover: false);
      }
      _updateFocusHighlights();
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_handleFocusHighlightModeChange);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => highlightsExist || (_splashes != null && _splashes!.isNotEmpty);

  Color getHighlightColorForType(HighlightType type) {
    const Set<MaterialState> focused = <MaterialState>{MaterialState.focused};
    const Set<MaterialState> hovered = <MaterialState>{MaterialState.hovered};

    switch (type) {
      // The pressed state triggers a ripple (ink splash), per the current
      // Material Design spec. A separate highlight is no longer used.
      // See https://material.io/design/interaction/states.html#pressed
      case HighlightType.pressed:
        return widget.highlightColor ?? Theme.of(context).highlightColor;
      case HighlightType.focus:
        return widget.overlayColor?.resolve(focused) ?? widget.focusColor ?? Theme.of(context).focusColor;
      case HighlightType.hover:
        return widget.overlayColor?.resolve(hovered) ?? widget.hoverColor ?? Theme.of(context).hoverColor;
    }
  }

  Duration getFadeDurationForType(HighlightType type) {
    switch (type) {
      case HighlightType.pressed:
        return const Duration(milliseconds: 200);
      case HighlightType.hover:
      case HighlightType.focus:
        return const Duration(milliseconds: 50);
    }
  }

  // This method is modified by @Aoi-hosizora.
  void updateHighlight(HighlightType type, {required bool value, bool callOnHover = true}) {
    final InkHighlight? highlight = _highlights[type];
    void handleInkRemoval() {
      assert(_highlights[type] != null);
      _highlights[type] = null;
      updateKeepAlive();
    }

    if (type == HighlightType.pressed) {
      parentState?.markChildInkResponsePressed(this, value);
    }
    if (value == (highlight != null && highlight.active)) {
      return;
    }
    if (value) {
      if (highlight == null) {
        final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
        _highlights[type] = InkHighlight(
          controller: Material.of(context)!,
          referenceBox: referenceBox,
          color: getHighlightColorForType(type),
          shape: widget.highlightShape,
          radius: widget.getRadius?.call(referenceBox) /* <<< */,
          borderRadius: widget.borderRadius,
          customBorder: widget.customBorder,
          rectCallback: widget.getRect?.call(referenceBox) == null ? null : () => widget.getRect!.call(referenceBox)! /* <<< */,
          onRemoved: handleInkRemoval,
          textDirection: Directionality.of(context),
          fadeDuration: widget.highlightFadeDuration?.call(type) ?? getFadeDurationForType(type) /* <<< */,
        );
        updateKeepAlive();
      } else {
        highlight.activate();
      }
    } else {
      highlight!.deactivate();
    }
    assert(value == (_highlights[type] != null && _highlights[type]!.active));

    switch (type) {
      case HighlightType.pressed:
        widget.onHighlightChanged?.call(value);
        break;
      case HighlightType.hover:
        if (callOnHover) {
          widget.onHover?.call(value);
        }
        break;
      case HighlightType.focus:
        break;
    }
  }

  // This method is modified by @Aoi-hosizora.
  InteractiveInkFeature _createInkFeature(Offset globalPosition) {
    final MaterialInkController inkController = Material.of(context)!;
    final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
    final Offset position = referenceBox.globalToLocal(globalPosition);
    const Set<MaterialState> pressed = <MaterialState>{MaterialState.pressed};
    final Color color = widget.overlayColor?.resolve(pressed) ?? widget.splashColor ?? Theme.of(context).splashColor;
    final double? radius = widget.getRadius?.call(referenceBox); // <<<
    final RectCallback? rectCallback = !widget.containedInkWell
        ? null
        : widget.getRect?.call(referenceBox) == null
            ? null
            : () => widget.getRect!.call(referenceBox)!; // <<<
    final BorderRadius? borderRadius = widget.borderRadius;
    final ShapeBorder? customBorder = widget.customBorder;

    InteractiveInkFeature? splash;
    void onRemoved() {
      if (_splashes != null) {
        assert(_splashes!.contains(splash));
        _splashes!.remove(splash);
        if (_currentSplash == splash) {
          _currentSplash = null;
        }
        updateKeepAlive();
      } // else we're probably in deactivate()
    }

    splash = (widget.splashFactory ?? Theme.of(context).splashFactory).create(
      controller: inkController,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: widget.containedInkWell,
      rectCallback: rectCallback /* <<< */,
      radius: radius /* <<< */,
      borderRadius: borderRadius,
      customBorder: customBorder,
      onRemoved: onRemoved,
      textDirection: Directionality.of(context),
    );

    return splash;
  }

  void _handleFocusHighlightModeChange(FocusHighlightMode mode) {
    if (!mounted) {
      return;
    }
    setState(() {
      _updateFocusHighlights();
    });
  }

  bool get _shouldShowFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return enabled && _hasFocus;
      case NavigationMode.directional:
        return _hasFocus;
    }
  }

  void _updateFocusHighlights() {
    final bool showFocus;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        showFocus = false;
        break;
      case FocusHighlightMode.traditional:
        showFocus = _shouldShowFocus;
        break;
    }
    updateHighlight(HighlightType.focus, value: showFocus);
  }

  bool _hasFocus = false;

  void _handleFocusUpdate(bool hasFocus) {
    _hasFocus = hasFocus;
    _updateFocusHighlights();
    widget.onFocusChange?.call(hasFocus);
  }

  void _handleTapDown(TapDownDetails details) {
    if (_anyChildInkResponsePressed) {
      return;
    }
    _startSplash(details: details);
    widget.onTapDown?.call(details);
  }

  void _startSplash({TapDownDetails? details, BuildContext? context}) {
    assert(details != null || context != null);

    final Offset globalPosition;
    if (context != null) {
      final RenderBox referenceBox = context.findRenderObject()! as RenderBox;
      assert(referenceBox.hasSize, 'InkResponse must be done with layout before starting a splash.');
      globalPosition = referenceBox.localToGlobal(referenceBox.paintBounds.center);
    } else {
      globalPosition = details!.globalPosition;
    }
    final InteractiveInkFeature splash = _createInkFeature(globalPosition);
    _splashes ??= HashSet<InteractiveInkFeature>();
    _splashes!.add(splash);
    _currentSplash = splash;
    updateKeepAlive();
    updateHighlight(HighlightType.pressed, value: true);
  }

  void _handleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    updateHighlight(HighlightType.pressed, value: false);
    if (widget.onTap != null) {
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    _currentSplash?.cancel();
    _currentSplash = null;
    widget.onTapCancel?.call();
    updateHighlight(HighlightType.pressed, value: false);
  }

  void _handleDoubleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    widget.onDoubleTap?.call();
  }

  void _handleLongPress() {
    _currentSplash?.confirm();
    _currentSplash = null;
    if (widget.onLongPress != null) {
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      widget.onLongPress!();
    }
  }

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes!;
      _splashes = null;
      for (final InteractiveInkFeature splash in splashes) {
        splash.dispose();
      }
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    for (final HighlightType highlight in _highlights.keys) {
      _highlights[highlight]?.dispose();
      _highlights[highlight] = null;
    }
    parentState?.markChildInkResponsePressed(this, false);
    super.deactivate();
  }

  bool _isWidgetEnabled(CustomInkResponse widget) {
    return widget.onTap != null || widget.onDoubleTap != null || widget.onLongPress != null;
  }

  bool get enabled => _isWidgetEnabled(widget);

  void _handleMouseEnter(PointerEnterEvent event) {
    _hovering = true;
    if (enabled) {
      _handleHoverChange();
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    _hovering = false;
    // If the exit occurs after we've been disabled, we still
    // want to take down the highlights and run widget.onHover.
    _handleHoverChange();
  }

  void _handleHoverChange() {
    updateHighlight(HighlightType.hover, value: _hovering);
  }

  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return enabled && widget.canRequestFocus;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    for (final HighlightType type in _highlights.keys) {
      _highlights[type]?.color = getHighlightColorForType(type);
    }

    const Set<MaterialState> pressed = <MaterialState>{MaterialState.pressed};
    _currentSplash?.color = widget.overlayColor?.resolve(pressed) ?? widget.splashColor ?? Theme.of(context).splashColor;

    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled) MaterialState.disabled,
        if (_hovering && enabled) MaterialState.hovered,
        if (_hasFocus) MaterialState.focused,
      },
    );
    return _ParentInkResponseProvider(
      state: this,
      child: Actions(
        actions: _actionMap,
        child: Focus(
          focusNode: widget.focusNode,
          canRequestFocus: _canRequestFocus,
          onFocusChange: _handleFocusUpdate,
          autofocus: widget.autofocus,
          child: MouseRegion(
            cursor: effectiveMouseCursor,
            onEnter: _handleMouseEnter,
            onExit: _handleMouseExit,
            child: Semantics(
              onTap: widget.excludeFromSemantics || widget.onTap == null ? null : _simulateTap,
              onLongPress: widget.excludeFromSemantics || widget.onLongPress == null ? null : _simulateLongPress,
              child: GestureDetector(
                onTapDown: enabled ? _handleTapDown : null,
                onTap: enabled ? _handleTap : null,
                onTapCancel: enabled ? _handleTapCancel : null,
                onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
                onLongPress: widget.onLongPress != null ? _handleLongPress : null,
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Returns the [Rect] of [TableRow] with given [RenderBox]. This is a helper
/// function for [CustomInkResponse.getRect], which is used to fix ink effect
/// bug of [TableRowInkWell].
Rect getTableRowRect(RenderBox referenceBox) {
  const helper = TableRowInkWell();
  var callback = helper.getRectCallback(referenceBox);
  return callback();
}

/// This function is the same as [math.sqrt].
num calcSqrt(num n) {
  return math.sqrt(n);
}

/// This function can be used to calculate the diagonal of given width and height.
num calcDiagonal(num width, num height) {
  return math.sqrt(width * width + height * height);
}
