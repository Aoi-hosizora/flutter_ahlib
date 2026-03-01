import 'package:flutter/material.dart';

/// An extension for [TextTheme] in order to compat with flutter2.
extension TextThemeExtension on TextTheme {
  // Headline
  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline4 => headlineLarge;
  TextStyle? get headline5 => headlineMedium;
  TextStyle? get headline6 => headlineSmall;

  // Subtitle
  TextStyle? get subtitle1 => titleMedium; // titleLarge
  TextStyle? get subtitle2 => titleSmall; // titleMedium
  TextStyle? get subtitle => titleMedium;

  // Body
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;

  // Others
  TextStyle? get caption => bodySmall;
  TextStyle? get button => labelLarge;
  TextStyle? get overline => labelSmall;
}

/// Gets preferred [TextTheme] in material3 to render text like material2.
TextTheme preferredMaterial2TextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w400, letterSpacing: 0.0),

    headlineLarge: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, letterSpacing: 0.0),
    headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, letterSpacing: 0.15),

    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.15), // appBar
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1),

    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4),

    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}
