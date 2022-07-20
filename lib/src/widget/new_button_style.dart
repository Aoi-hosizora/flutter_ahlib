import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/widget/custom_ink_feature.dart';

// Refers to: https://docs.google.com/document/d/1yohSuYrvyya5V1hB6j9pJskavCdVq9sVeTqSoEPsWH0.
//
// Old Widget    | Old Theme   | New Widget     | New Theme
// --------------+-------------+----------------+--------------------
// FlatButton    | ButtonTheme | TextButton     | TextButtonTheme
// RaisedButton  | ButtonTheme | ElevatedButton | ElevatedButtonTheme
// OutlineButton | ButtonTheme | OutlinedButton | OutlinedButtonTheme

// ignore_for_file: deprecated_member_use

/// Returns a [ButtonStyle] that is used to make a [TextButton] look like a deprecated [FlatButton],
/// but with given styles.
ButtonStyle flatButtonStyle({
  Color? primary,
  Color? onSurface,
  Color? backgroundColor,
  Color? shadowColor,
  Color? splashColor,
  double? elevation,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? minimumSize,
  Size? fixedSize,
  Size? maximumSize,
  BorderSide? side,
  OutlinedBorder? shape,
  MouseCursor? enabledMouseCursor,
  MouseCursor? disabledMouseCursor,
  VisualDensity? visualDensity,
  MaterialTapTargetSize? tapTargetSize,
  Duration? animationDuration,
  bool? enableFeedback,
  AlignmentGeometry? alignment,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  var style = TextButton.styleFrom(
    // fields for FlatButton
    primary: primary ?? Colors.black87,
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
    // fields for TextButton
    onSurface: onSurface,
    backgroundColor: backgroundColor,
    shadowColor: shadowColor,
    elevation: elevation,
    textStyle: textStyle,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    side: side,
    enabledMouseCursor: enabledMouseCursor,
    disabledMouseCursor: disabledMouseCursor,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
    alignment: alignment,
    splashFactory: splashFactory,
  );
  if (splashColor != null) {
    // add extra splashColor style
    style = style.copyWith(
      overlayColor: MaterialStateProperty.resolveWith(
        (s) => s.contains(MaterialState.pressed) ? splashColor : null,
      ),
    );
  }
  return style;
}

/// Returns a [ButtonStyle] that is used to make a [ElevatedButton] look like a deprecated [RaisedButton],
/// but with given styles.
ButtonStyle raisedButtonStyle({
  Color? primary,
  Color? onPrimary,
  Color? onSurface,
  Color? shadowColor,
  Color? splashColor,
  double? elevation,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? minimumSize,
  Size? fixedSize,
  Size? maximumSize,
  BorderSide? side,
  OutlinedBorder? shape,
  MouseCursor? enabledMouseCursor,
  MouseCursor? disabledMouseCursor,
  VisualDensity? visualDensity,
  MaterialTapTargetSize? tapTargetSize,
  Duration? animationDuration,
  bool? enableFeedback,
  AlignmentGeometry? alignment,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  var style = ElevatedButton.styleFrom(
    // fields for RaisedButton
    onPrimary: onPrimary ?? Colors.black87,
    primary: primary ?? Colors.grey[300],
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
    // fields for ElevatedButton
    onSurface: onSurface,
    shadowColor: shadowColor,
    elevation: elevation,
    textStyle: textStyle,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    side: side,
    enabledMouseCursor: enabledMouseCursor,
    disabledMouseCursor: disabledMouseCursor,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
    alignment: alignment,
    splashFactory: splashFactory,
  );
  if (splashColor != null) {
    // add extra splashColor style
    style = style.copyWith(
      overlayColor: MaterialStateProperty.resolveWith(
        (s) => s.contains(MaterialState.pressed) ? splashColor : null,
      ),
    );
  }
  return style;
}

/// Returns a [ButtonStyle] that is used to make a [OutlinedButton] look like a deprecated [OutlineButton],
/// but with given styles.
ButtonStyle outlineButtonStyle(
  ColorScheme colorScheme, {
  Color? primary,
  Color? onSurface,
  Color? backgroundColor,
  Color? shadowColor,
  Color? splashColor,
  double? elevation,
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
  Size? minimumSize,
  Size? fixedSize,
  Size? maximumSize,
  BorderSide? side,
  OutlinedBorder? shape,
  MouseCursor? enabledMouseCursor,
  MouseCursor? disabledMouseCursor,
  VisualDensity? visualDensity,
  MaterialTapTargetSize? tapTargetSize,
  Duration? animationDuration,
  bool? enableFeedback,
  AlignmentGeometry? alignment,
  InteractiveInkFeatureFactory? splashFactory,
}) {
  var style = OutlinedButton.styleFrom(
    // fields for OutlineButton
    primary: primary ?? Colors.black87,
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    shape: shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
    // fields for OutlinedButton
    onSurface: onSurface,
    backgroundColor: backgroundColor,
    shadowColor: shadowColor,
    elevation: elevation,
    textStyle: textStyle,
    minimumSize: minimumSize,
    fixedSize: fixedSize,
    maximumSize: maximumSize,
    side: side,
    enabledMouseCursor: enabledMouseCursor,
    disabledMouseCursor: disabledMouseCursor,
    visualDensity: visualDensity,
    tapTargetSize: tapTargetSize,
    animationDuration: animationDuration,
    enableFeedback: enableFeedback,
    alignment: alignment,
    splashFactory: splashFactory,
  );
  if (splashColor != null) {
    // add extra splashColor style
    style = style.copyWith(
      overlayColor: MaterialStateProperty.resolveWith(
        (s) => s.contains(MaterialState.pressed) ? splashColor : null,
      ),
    );
  }
  if (side == null) {
    // use default side style
    style = style.copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(
              color: colorScheme.primary,
              width: 1,
            );
          }
          return null; // Defer to the widget's default.
        },
      ),
    );
  }
  return style;
}

/// The preferred splash color for [TextButton], [OutlinedButton], [InkWell], [InkResponse], etc by Aoi-hosizora :)
const double preferredSplashColorOpacity = 0.20;

/// The preferred splash color for light [ElevatedButton] by Aoi-hosizora :)
const double preferredSplashColorOpacityForLightElevated = 0.26;

/// The preferred splash color for dark [ElevatedButton] by Aoi-hosizora :)
const double preferredSplashColorOpacityForDarkElevated = 0.40;

/// Returns the preferred [TextButton]'s [ButtonStyle] by Aoi-hosizora :)
ButtonStyle preferredTextButtonStyle(
  ColorScheme colorScheme, [
  double splashColorOpacity = preferredSplashColorOpacity,
]) =>
    flatButtonStyle(
      primary: colorScheme.primary,
      splashColor: colorScheme.primary.withOpacity(splashColorOpacity), // <<<
      splashFactory: CustomInkRipple.preferredSplashFactory,
    );

/// Returns the preferred [ElevatedButton]'s [ButtonStyle] by Aoi-hosizora :)
ButtonStyle preferredElevatedButtonStyle(
  ColorScheme colorScheme, [
  double splashColorOpacityForLight = preferredSplashColorOpacityForLightElevated,
  double splashColorOpacityForDark = preferredSplashColorOpacityForDarkElevated,
]) =>
    raisedButtonStyle(
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      splashColor: colorScheme.onPrimary.computeLuminance() < 0.5 ? colorScheme.onPrimary.withOpacity(splashColorOpacityForLight) : colorScheme.onPrimary.withOpacity(splashColorOpacityForDark), // <<<
      splashFactory: CustomInkRipple.preferredSplashFactory,
    );

/// Returns the preferred [OutlinedButton]'s [ButtonStyle] by Aoi-hosizora :)
ButtonStyle preferredOutlinedButtonStyle(
  ColorScheme colorScheme, [
  double splashColorOpacity = preferredSplashColorOpacity,
]) =>
    outlineButtonStyle(
      colorScheme,
      primary: colorScheme.primary,
      splashColor: colorScheme.primary.withOpacity(splashColorOpacity), // <<<
      splashFactory: CustomInkRipple.preferredSplashFactory,
    );

/// An extension for [ThemeData].
extension ThemeDataExtension on ThemeData {
  /// Creates a copy of [ThemeData] but with given [InteractiveInkFeatureFactory] for splash factory of
  /// normal widgets and some kinds of button widgets.
  ThemeData withSplashFactory(InteractiveInkFeatureFactory factory) => copyWith(
        splashFactory: factory,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
        outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
      );

  /// Creates a copy of [ThemeData] but with referred [ButtonStyle] for [ElevatedButton], [OutlinedButton]
  /// and [TextButton].
  ThemeData withPreferredButtonStyles() => copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(style: preferredElevatedButtonStyle(colorScheme)),
        outlinedButtonTheme: OutlinedButtonThemeData(style: preferredOutlinedButtonStyle(colorScheme)),
        textButtonTheme: TextButtonThemeData(style: preferredTextButtonStyle(colorScheme)),
      );
}
