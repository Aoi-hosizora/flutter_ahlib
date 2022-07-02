// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Note: The file is based on Flutter's source code, and is modified by Aoi-hosizora (GitHub: @Aoi-hosizora).
// This file keeps almost the same as https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/ink_ripple.dart.

import 'dart:math' as math;

import 'package:flutter/material.dart';

// const Duration _kUnconfirmedRippleDuration = Duration(milliseconds: 1000); // unconfirmed ripple
// const Duration _kFadeInDuration = Duration(milliseconds: 75); // unconfirmed fade-in color
// const Duration _kRadiusDuration = Duration(milliseconds: 225); // confirmed ripple
// const Duration _kFadeOutDuration = Duration(milliseconds: 375); // confirmed fade-out color
// const Duration _kCancelDuration = Duration(milliseconds: 75); // canceled fade-out color
//
// // The fade out begins 225ms after the _fadeOutController starts. See confirm().
// const double _kFadeOutIntervalStart = 225.0 / 375.0;

/// The setting for [CustomInkRipple], this class contains some durations options
/// for ripple effect and color fading.
class CustomInkRippleSetting {
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
    unconfirmedRippleDuration: Duration(milliseconds: 250) /* 1000 -> 250 */,
    unconfirmedFadeInDuration: Duration(milliseconds: 75) /* 75 -> 75 */,
    confirmedRippleDuration: Duration(milliseconds: 250) /* 225 -> 250 */,
    confirmedFadeoutDuration: Duration(milliseconds: 150) /* 150 -> 150 */,
    confirmedFadeoutInterval: Duration(milliseconds: 200) /* 225 -> 200 */,
    canceledFadeOutDuration: Duration(milliseconds: 75),
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

  /// Creates a copy of this [CustomInkRippleSetting] but with the given scales
  /// (must be larger or equal to zero) replaced with the new values.
  static CustomInkRippleSetting copyWithInScale({
    double? unconfirmedRippleDurationScale,
    double? unconfirmedFadeInDurationScale,
    double? confirmedRippleDurationScale,
    double? confirmedFadeoutDurationScale,
    double? confirmedFadeoutIntervalScale,
    double? canceledFadeOutDurationScale,
  }) {
    assert(unconfirmedRippleDurationScale == null || unconfirmedRippleDurationScale >= 0.0);
    assert(unconfirmedFadeInDurationScale == null || unconfirmedFadeInDurationScale >= 0.0);
    assert(confirmedRippleDurationScale == null || confirmedRippleDurationScale >= 0.0);
    assert(confirmedFadeoutDurationScale == null || confirmedFadeoutDurationScale >= 0.0);
    assert(confirmedFadeoutIntervalScale == null || confirmedFadeoutIntervalScale >= 0.0);
    assert(canceledFadeOutDurationScale == null || canceledFadeOutDurationScale >= 0.0);

    Duration? newUnconfirmedRippleDuration;
    if (unconfirmedRippleDurationScale != null) {
      newUnconfirmedRippleDuration = Duration(milliseconds: (defaultSetting.unconfirmedRippleDuration.inMilliseconds * unconfirmedRippleDurationScale).toInt());
    }
    Duration? newUnconfirmedFadeInDuration;
    if (unconfirmedFadeInDurationScale != null) {
      newUnconfirmedFadeInDuration = Duration(milliseconds: (defaultSetting.unconfirmedFadeInDuration.inMilliseconds * unconfirmedFadeInDurationScale).toInt());
    }
    Duration? newConfirmedRippleDuration;
    if (confirmedRippleDurationScale != null) {
      newConfirmedRippleDuration = Duration(milliseconds: (defaultSetting.confirmedRippleDuration.inMilliseconds * confirmedRippleDurationScale).toInt());
    }
    Duration? newConfirmedFadeoutDuration;
    if (confirmedFadeoutDurationScale != null) {
      newConfirmedFadeoutDuration = Duration(milliseconds: (defaultSetting.confirmedFadeoutDuration.inMilliseconds * confirmedFadeoutDurationScale).toInt());
    }
    Duration? newConfirmedFadeoutInterval;
    if (confirmedFadeoutIntervalScale != null) {
      newConfirmedFadeoutInterval = Duration(milliseconds: (defaultSetting.confirmedFadeoutInterval.inMilliseconds * confirmedFadeoutIntervalScale).toInt());
    }
    Duration? newCanceledFadeOutDuration;
    if (canceledFadeOutDurationScale != null) {
      newCanceledFadeOutDuration = Duration(milliseconds: (defaultSetting.canceledFadeOutDuration.inMilliseconds * canceledFadeOutDurationScale).toInt());
    }

    return CustomInkRippleSetting(
      unconfirmedRippleDuration: newUnconfirmedRippleDuration ?? defaultSetting.unconfirmedRippleDuration,
      unconfirmedFadeInDuration: newUnconfirmedFadeInDuration ?? defaultSetting.unconfirmedFadeInDuration,
      confirmedRippleDuration: newConfirmedRippleDuration ?? defaultSetting.confirmedRippleDuration,
      confirmedFadeoutDuration: newConfirmedFadeoutDuration ?? defaultSetting.confirmedFadeoutDuration,
      confirmedFadeoutInterval: newConfirmedFadeoutInterval ?? defaultSetting.confirmedFadeoutInterval,
      canceledFadeOutDuration: newCanceledFadeOutDuration ?? defaultSetting.canceledFadeOutDuration,
    );
  }
}

RectCallback? _getClipCallback(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback, Offset position) {
  final Size size = rectCallback != null ? rectCallback().size : referenceBox.size;
  final double d1 = size.bottomRight(Offset.zero).distance;
  final double d2 = (size.topRight(Offset.zero) - size.bottomLeft(Offset.zero)).distance;
  return math.max(d1, d2) / 2.0;
}

/// The factory of [CustomInkRipple], you can use [CustomInkRipple.splashFactory]
/// to create a default [CustomInkRipple], you can also use this class with [setting]
/// field to create a custom [CustomInkRipple].
class CustomInkRippleFactory extends InteractiveInkFeatureFactory {
  const CustomInkRippleFactory({this.setting = CustomInkRippleSetting.defaultSetting});

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

/// Creates a copy of [ThemeData] but with given [InteractiveInkFeatureFactory] for
/// splash factory.
ThemeData themeDataWithSplashFactory(ThemeData data, InteractiveInkFeatureFactory factory) {
  return data.copyWith(
    splashFactory: factory,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
  );
}

/// A visual reaction on a piece of [Material] to user input, similar to
/// [InkRipple] but with [CustomInkRippleSetting].
///
/// A circular ink feature whose origin starts at the input touch point and
/// whose radius expands from 60% of the final radius. The splash origin
/// animates to the center of its [referenceBox].
///
/// This object is rarely created directly. Instead of creating an ink ripple,
/// consider using an [InkResponse] or [InkWell] widget, which uses
/// gestures (such as tap and long-press) to trigger ink splashes. This class
/// is used when the [Theme]'s [ThemeData.splashFactory] is [CustomInkRipple.splashFactory].
///
/// See also:
///
///  * [InkRipple], which is an ink splash feature that expands more
///    aggressively than this class does.
///  * [InkSplash], which is an ink splash feature that expands less
///    aggressively than the ripple.
///  * [InkResponse], which uses gestures to trigger ink highlights and ink
///    splashes in the parent [Material].
///  * [InkWell], which is a rectangular [InkResponse] (the most common type of
///    ink response).
///  * [Material], which is the widget on which the ink splash is painted.
///  * [InkHighlight], which is an ink feature that emphasizes a part of a
///    [Material].
class CustomInkRipple extends InteractiveInkFeature {
  /// Begin a ripple, centered at [position] relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If [containedInkWell] is true, then the ripple will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by [rectCallback], if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If [containedInkWell] is false, then [rectCallback] should be null.
  /// The ink ripple is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the ripple is removed, [onRemoved] will be called.
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
        _targetRadius = radius ?? _getTargetRadius(referenceBox, containedInkWell, rectCallback, position),
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
        end: _targetRadius + 5.0,
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
