// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';

// Note: The file is based on Flutter's source code, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source codes:
// - InkRipple: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/ink_ripple.dart
// - InkSplash: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/ink_splash.dart

/// The setting for [CustomInkRipple], this class contains some durations options
/// for ripple effect and color fading.
class CustomInkRippleSetting {
  // const Duration _kUnconfirmedRippleDuration = Duration(milliseconds: 1000); // unconfirmed ripple
  // const Duration _kFadeInDuration = Duration(milliseconds: 75); // unconfirmed fade-in color
  // const Duration _kRadiusDuration = Duration(milliseconds: 225); // confirmed ripple
  // const Duration _kFadeOutDuration = Duration(milliseconds: 375); // confirmed fade-out color
  // const Duration _kCancelDuration = Duration(milliseconds: 75); // canceled fade-out color
  //
  // // The fade out begins 225ms after the _fadeOutController starts. See confirm().
  // const double _kFadeOutIntervalStart = 225.0 / 375.0;

  const CustomInkRippleSetting({
    this.unconfirmedRippleDuration = const Duration(milliseconds: 1000),
    this.unconfirmedFadeInDuration = const Duration(milliseconds: 75),
    this.confirmedRippleDuration = const Duration(milliseconds: 225),
    this.confirmedFadeoutDuration = const Duration(milliseconds: 150), // 375 -> 150
    this.confirmedFadeoutInterval = const Duration(milliseconds: 225), // 225/375 == 225/(150+225) -> 225
    this.canceledFadeOutDuration = const Duration(milliseconds: 75),
  });

  final Duration unconfirmedRippleDuration; // _kUnconfirmedRippleDuration
  final Duration unconfirmedFadeInDuration; // _kFadeInDuration
  final Duration confirmedRippleDuration; // _kRadiusDuration
  final Duration confirmedFadeoutDuration;
  final Duration confirmedFadeoutInterval;
  final Duration canceledFadeOutDuration; // _kCancelDuration

  Duration get _confirmedFadeoutDuration => // _kFadeOutDuration
      confirmedFadeoutDuration + confirmedFadeoutInterval;

  double get _confirmedFadeoutInterval => // _kFadeOutIntervalStart
      confirmedFadeoutInterval.inMilliseconds / (confirmedFadeoutDuration.inMilliseconds + confirmedFadeoutInterval.inMilliseconds);

  /// The default, or said, the original settings of [InkRipple] in Flutter.
  static const CustomInkRippleSetting defaultSetting = CustomInkRippleSetting(
    unconfirmedRippleDuration: Duration(milliseconds: 1000),
    unconfirmedFadeInDuration: Duration(milliseconds: 75),
    confirmedRippleDuration: Duration(milliseconds: 225),
    confirmedFadeoutDuration: Duration(milliseconds: 150),
    confirmedFadeoutInterval: Duration(milliseconds: 225),
    canceledFadeOutDuration: Duration(milliseconds: 75),
  );

  /// The preferred [CustomInkRipple] setting by Aoi-hosizora :)
  static const CustomInkRippleSetting preferredSetting = CustomInkRippleSetting(
    unconfirmedRippleDuration: Duration(milliseconds: 300) /* 1000 -> 300 */,
    unconfirmedFadeInDuration: Duration(milliseconds: 75) /* 75 -> 75 */,
    confirmedRippleDuration: Duration(milliseconds: 200) /* 225 -> 200 */,
    confirmedFadeoutDuration: Duration(milliseconds: 150) /* 150 -> 150 */,
    confirmedFadeoutInterval: Duration(milliseconds: 200) /* 225 -> 200 */,
    canceledFadeOutDuration: Duration(milliseconds: 125) /* 75 -> 125 */,
  );

  /// Creates a copy of this [CustomInkRippleSetting] but with the given fields
  /// replaced with the new values.
  static CustomInkRippleSetting copyWith({
    Duration? unconfirmedRippleDuration,
    Duration? unconfirmedFadeInDuration,
    Duration? confirmedRippleDuration,
    Duration? confirmedFadeoutDuration,
    Duration? confirmedFadeoutInterval,
    Duration? canceledFadeOutDuration,
  }) {
    return CustomInkRippleSetting(
      unconfirmedRippleDuration: unconfirmedRippleDuration ?? defaultSetting.unconfirmedRippleDuration,
      unconfirmedFadeInDuration: unconfirmedFadeInDuration ?? defaultSetting.unconfirmedFadeInDuration,
      confirmedRippleDuration: confirmedRippleDuration ?? defaultSetting.confirmedRippleDuration,
      confirmedFadeoutDuration: confirmedFadeoutDuration ?? defaultSetting.confirmedFadeoutDuration,
      confirmedFadeoutInterval: confirmedFadeoutInterval ?? defaultSetting.confirmedFadeoutInterval,
      canceledFadeOutDuration: canceledFadeOutDuration ?? defaultSetting.canceledFadeOutDuration,
    );
  }
}

/// The setting for [CustomInkSplash], this class contains some durations options
/// for ripple effect and color fading.
class CustomInkSplashSetting {
  // const Duration _kUnconfirmedSplashDuration = Duration(seconds: 1);
  // const Duration _kSplashFadeDuration = Duration(milliseconds: 200);
  //
  // const double _kSplashInitialSize = 0.0; // logical pixels
  // const double _kSplashConfirmedVelocity = 1.0; // logical pixels per millisecond

  const CustomInkSplashSetting({
    this.unconfirmedSplashDuration = const Duration(milliseconds: 1000),
    this.splashFadeDuration = const Duration(milliseconds: 200),
    this.splashConfirmedVelocity = 1.0,
  });

  final Duration unconfirmedSplashDuration; // _kUnconfirmedSplashDuration
  final Duration splashFadeDuration; // _kSplashFadeDuration
  static const double splashInitialSize = 0.0; // _kSplashInitialSize
  final double splashConfirmedVelocity; // _kSplashConfirmedVelocity

  /// The default, or said, the original settings of [InkSplash] in Flutter.
  static const CustomInkSplashSetting defaultSetting = CustomInkSplashSetting(
    unconfirmedSplashDuration: Duration(milliseconds: 1000),
    splashFadeDuration: Duration(milliseconds: 200),
    splashConfirmedVelocity: 1.0,
  );

  /// The preferred [CustomInkSplash] setting by Aoi-hosizora :)
  static const CustomInkSplashSetting preferredSetting = CustomInkSplashSetting(
    unconfirmedSplashDuration: Duration(milliseconds: 300) /* 1000 -> 300 */,
    splashFadeDuration: Duration(milliseconds: 400) /* 200 -> 400 */,
    splashConfirmedVelocity: 0.4, // 1.0 -> 0.4
  );

  /// Creates a copy of this [CustomInkSplashSetting] but with the given fields
  /// replaced with the new values.
  static CustomInkSplashSetting copyWith({
    Duration? unconfirmedSplashDuration,
    Duration? splashFadeDuration,
    double? splashConfirmedVelocity,
  }) {
    return CustomInkSplashSetting(
      unconfirmedSplashDuration: unconfirmedSplashDuration ?? defaultSetting.unconfirmedSplashDuration,
      splashFadeDuration: splashFadeDuration ?? defaultSetting.splashFadeDuration,
      splashConfirmedVelocity: splashConfirmedVelocity ?? defaultSetting.splashConfirmedVelocity,
    );
  }
}

/// The factory of [CustomInkRipple], you can use [CustomInkRipple.splashFactory]
/// to create a default [CustomInkRipple], you can also use this class with [setting]
/// field to create a custom [CustomInkRipple].
class CustomInkRippleFactory extends InteractiveInkFeatureFactory {
  const CustomInkRippleFactory({
    this.setting = CustomInkRippleSetting.defaultSetting,
  });

  final CustomInkRippleSetting setting;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomInkRipple(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
      setting: setting,
    );
  }
}

/// The factory of [CustomInkSplash], you can use [CustomInkSplash.splashFactory]
/// to create a default [CustomInkSplash], you can also use this class with [setting]
/// field to create a custom [CustomInkSplash].
class CustomInkSplashFactory extends InteractiveInkFeatureFactory {
  const CustomInkSplashFactory({
    this.setting = CustomInkSplashSetting.defaultSetting,
  });

  final CustomInkSplashSetting setting;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomInkSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
      setting: setting,
    );
  }
}

RectCallback? _getClipCallback(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) {
    return () => Offset.zero & referenceBox.size;
  }
  return null;
}

double _getTargetRadiusForRipple(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback, Offset position) {
  final Size size = rectCallback != null ? rectCallback().size : referenceBox.size;
  final double d1 = size.bottomRight(Offset.zero).distance;
  final double d2 = (size.topRight(Offset.zero) - size.bottomLeft(Offset.zero)).distance;
  return math.max(d1, d2) / 2.0;
}

/// A visual reaction on a piece of [Material] to user input, similar to
/// [InkRipple] but with [CustomInkRippleSetting].
///
/// A circular ink feature whose origin starts at the input touch point and
/// whose radius expands from 60% of the final radius. The splash origin
/// animates to the center of its [referenceBox].
class CustomInkRipple extends InteractiveInkFeature {
  CustomInkRipple({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
    CustomInkRippleSetting setting = CustomInkRippleSetting.defaultSetting,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _textDirection = textDirection,
        _targetRadius = radius ?? _getTargetRadiusForRipple(referenceBox, containedInkWell, rectCallback, position),
        _clipCallback = _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _setting = setting,
        super(controller: controller, referenceBox: referenceBox, color: color, onRemoved: onRemoved) {
    // Immediately begin fading-in the initial splash.
    _fadeInController = AnimationController(duration: _setting.unconfirmedFadeInDuration /* _kFadeInDuration */, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _fadeIn = _fadeInController.drive(IntTween(
      begin: 0,
      end: color.alpha,
    ));

    // Controls the splash radius and its center. Starts upon confirm.
    _radiusController = AnimationController(duration: _setting.unconfirmedRippleDuration /* _kUnconfirmedRippleDuration */, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    // Initial splash diameter is 60% of the target diameter, final
    // diameter is 10dps larger than the target diameter.
    _radius = _radiusController.drive(
      Tween<double>(
        begin: _targetRadius * 0.30,
        end: _targetRadius, // + 5.0
      ).chain(_easeCurveTween),
    );

    // Controls the splash radius and its center. Starts upon confirm however its
    // Interval delays changes until the radius expansion has completed.
    _fadeOutController = AnimationController(duration: _setting._confirmedFadeoutDuration /* _kFadeOutDuration */, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _fadeOutIntervalTween = CurveTween(curve: Interval(_setting._confirmedFadeoutInterval /* _kFadeOutIntervalStart */, 1.0));
    _fadeOut = _fadeOutController.drive(
      IntTween(
        begin: color.alpha,
        end: 0,
      ).chain(_fadeOutIntervalTween),
    );

    controller.addInkFeature(this);
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final TextDirection _textDirection;
  final CustomInkRippleSetting _setting;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _fadeIn;
  late AnimationController _fadeInController;

  late Animation<int> _fadeOut;
  late AnimationController _fadeOutController;

  /// Used to specify this type of ink splash with [CustomInkRippleSetting.defaultSetting]
  /// for an [InkWell], [InkResponse], material [Theme], or [ButtonStyle].
  static const InteractiveInkFeatureFactory splashFactory = CustomInkRippleFactory(setting: CustomInkRippleSetting.defaultSetting);

  /// Used to specify this type of ink splash with [CustomInkRippleSetting.preferredSetting]
  /// for an [InkWell], [InkResponse], material [Theme], or [ButtonStyle].
  static const InteractiveInkFeatureFactory preferredSplashFactory = CustomInkRippleFactory(setting: CustomInkRippleSetting.preferredSetting);

  static final Animatable<double> _easeCurveTween = CurveTween(curve: Curves.ease);
  late final Animatable<double> _fadeOutIntervalTween; // CurveTween(curve: const Interval(_kFadeOutIntervalStart, 1.0))

  @override
  void confirm() {
    _radiusController
      ..duration = _setting.confirmedRippleDuration /* _kRadiusDuration */
      ..forward();
    // This confirm may have been preceded by a cancel.
    _fadeInController.forward();
    _fadeOutController.animateTo(1.0, duration: _setting._confirmedFadeoutDuration /* _kFadeOutDuration */);
  }

  @override
  void cancel() {
    _fadeInController.stop();
    // Watch out: setting _fadeOutController's value to 1.0 will
    // trigger a call to _handleAlphaStatusChanged() which will
    // dispose _fadeOutController.
    final double fadeOutValue = 1.0 - _fadeInController.value;
    _fadeOutController.value = fadeOutValue;
    if (fadeOutValue < 1.0) _fadeOutController.animateTo(1.0, duration: _setting.canceledFadeOutDuration /* _kCancelDuration */);
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final int alpha = _fadeInController.isAnimating ? _fadeIn.value : _fadeOut.value;
    final Paint paint = Paint()..color = color.withAlpha(alpha);
    // Splash moves to the center of the reference box.
    final Offset center = Offset.lerp(
      _position,
      referenceBox.size.center(Offset.zero),
      Curves.ease.transform(_radiusController.value),
    )!;
    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: center,
      textDirection: _textDirection,
      radius: _radius.value,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }
}

double _getTargetRadiusForSplash(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback, Offset position) {
  if (containedInkWell) {
    final Size size = rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

/// A visual reaction on a piece of [Material] to user input, similar to
/// [InkSplash] but with [CustomInkSplashSetting].
///
/// A circular ink feature whose origin starts at the input touch point
/// and whose radius expands from zero.
class CustomInkSplash extends InteractiveInkFeature {
  CustomInkSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
    CustomInkSplashSetting setting = CustomInkSplashSetting.defaultSetting,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _targetRadius = radius ?? _getTargetRadiusForSplash(referenceBox, containedInkWell, rectCallback, position!),
        _clipCallback = _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        _textDirection = textDirection,
        _setting = setting,
        super(controller: controller, referenceBox: referenceBox, color: color, onRemoved: onRemoved) {
    _radiusController = AnimationController(duration: _setting.unconfirmedSplashDuration /* _kUnconfirmedSplashDuration */, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = _radiusController.drive(Tween<double>(
      begin: CustomInkSplashSetting.splashInitialSize /* _kSplashInitialSize */,
      end: _targetRadius,
    ));
    _alphaController = AnimationController(duration: _setting.splashFadeDuration /* _kSplashFadeDuration */, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha = _alphaController!.drive(IntTween(
      begin: color.alpha,
      end: 0,
    ));

    controller.addInkFeature(this);
  }

  final Offset? _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final bool _repositionToReferenceBox;
  final TextDirection _textDirection;
  final CustomInkSplashSetting _setting;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _alpha;
  AnimationController? _alphaController;

  /// Used to specify this type of ink splash with [CustomInkSplashSetting.defaultSetting]
  /// for an [InkWell], [InkResponse], material [Theme], or [ButtonStyle].
  static const InteractiveInkFeatureFactory splashFactory = CustomInkSplashFactory(setting: CustomInkSplashSetting.defaultSetting);

  /// Used to specify this type of ink splash with [CustomInkSplashSetting.preferredSetting]
  /// for an [InkWell], [InkResponse], material [Theme], or [ButtonStyle].
  static const InteractiveInkFeatureFactory preferredSplashFactory = CustomInkSplashFactory(setting: CustomInkSplashSetting.preferredSetting);

  @override
  void confirm() {
    final int duration = (_targetRadius / _setting.splashConfirmedVelocity /* _kSplashConfirmedVelocity */).floor();
    _radiusController
      ..duration = Duration(milliseconds: duration)
      ..forward();
    _alphaController!.forward();
  }

  @override
  void cancel() {
    _alphaController?.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      dispose();
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController!.dispose();
    _alphaController = null;
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withAlpha(_alpha.value);
    Offset? center = _position;
    if (_repositionToReferenceBox) {
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero), _radiusController.value);
    }
    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: center!,
      textDirection: _textDirection,
      radius: _radius.value,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }
}

/// An custom [InkResponse] with custom required [rectCallback] and [radius] for ink feature.
class CustomInkResponse extends InkResponse {
  const CustomInkResponse({
    Key? key,
    required Widget child,
    required GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapCancelCallback? onTapCancel,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    bool containedInkWell = false,
    BoxShape highlightShape = BoxShape.circle,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    MaterialStateProperty<Color?>? overlayColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    required double? radius,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    bool? enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    required this.rectCallback,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          mouseCursor: mouseCursor,
          containedInkWell: containedInkWell,
          highlightShape: highlightShape,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          overlayColor: overlayColor,
          splashColor: splashColor,
          splashFactory: splashFactory,
          radius: radius,
          borderRadius: borderRadius,
          customBorder: customBorder,
          enableFeedback: enableFeedback ?? true,
          excludeFromSemantics: excludeFromSemantics,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          onFocusChange: onFocusChange,
          autofocus: autofocus,
        );

  /// The [Rect] callback with [RenderBox] for [getRectCallback].
  final Rect Function(RenderBox referenceBox) rectCallback;

  /// The rectangle to use for the highlight effect and for clipping the splash effects if
  /// [containedInkWell] is true. Visit [InkResponse.getRectCallback] for details.
  @override
  RectCallback getRectCallback(RenderBox referenceBox) {
    return () => rectCallback(referenceBox);
  }
}

/// An custom [InkWell] with custom required [rectCallback] and [radius] for ink feature.
class CustomInkWell extends InkResponse {
  const CustomInkWell({
    Key? key,
    required Widget child,
    required GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapCancelCallback? onTapCancel,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    MaterialStateProperty<Color?>? overlayColor,
    Color? splashColor,
    InteractiveInkFeatureFactory? splashFactory,
    required double? radius,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    bool? enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool>? onFocusChange,
    bool autofocus = false,
    required this.rectCallback,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          mouseCursor: mouseCursor,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          overlayColor: overlayColor,
          splashColor: splashColor,
          splashFactory: splashFactory,
          radius: radius,
          borderRadius: borderRadius,
          customBorder: customBorder,
          enableFeedback: enableFeedback ?? true,
          excludeFromSemantics: excludeFromSemantics,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          onFocusChange: onFocusChange,
          autofocus: autofocus,
        );

  /// The [Rect] callback with [RenderBox] for [getRectCallback].
  final Rect Function(RenderBox referenceBox) rectCallback;

  /// The rectangle to use for the highlight effect and for clipping the splash effects if
  /// [containedInkWell] is true. Visit [InkResponse.getRectCallback] for details.
  @override
  RectCallback getRectCallback(RenderBox referenceBox) {
    return () => rectCallback(referenceBox);
  }
}

/// Returns the [Rect] of [TableRow] with given [RenderBox]. This is a helper function for
/// [CustomInkWell] and [CustomInkResponse], which is used to fix bug in [TableRowInkWell].
Rect getTableRowRect(RenderBox referenceBox) {
  var helper = const TableRowInkWell();
  var callback = helper.getRectCallback(referenceBox);
  return callback();
}
