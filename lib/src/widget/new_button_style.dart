import 'package:flutter/material.dart';

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
  return TextButton.styleFrom(
    // fields for FlatButton
    primary: primary ?? Colors.black87,
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
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
}

/// Returns a [ButtonStyle] that is used to make a [ElevatedButton] look like a deprecated [RaisedButton],
/// but with given styles.
ButtonStyle raisedButtonStyle({
  Color? primary,
  Color? onPrimary,
  Color? onSurface,
  Color? shadowColor,
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
  return ElevatedButton.styleFrom(
    // fields for RaisedButton
    onPrimary: onPrimary ?? Colors.black87,
    primary: primary ?? Colors.grey[300],
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
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
}

/// Returns a [ButtonStyle] that is used to make a [OutlinedButton] look like a deprecated [OutlineButton],
/// but with given styles.
ButtonStyle outlineButtonStyle(
  BuildContext context, {
  Color? primary,
  Color? onSurface,
  Color? backgroundColor,
  Color? shadowColor,
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
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
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
  if (side != null) {
    return style;
  }
  return style.copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          );
        }
        return null; // Defer to the widget's default.
      },
    ),
  );
}

/// An extension for [ThemeData].
extension ThemeDataExtension on ThemeData {
  /// Creates a copy of [ThemeData] but with given [InteractiveInkFeatureFactory] for splash factory of
  /// normal widgets and some kinds of button widgets.
  ThemeData withSplashFactory(InteractiveInkFeatureFactory factory) {
    return copyWith(
      splashFactory: factory,
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(splashFactory: factory)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(splashFactory: factory)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(splashFactory: factory)),
    );
  }
}
