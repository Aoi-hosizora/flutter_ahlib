import 'package:flutter/material.dart';

/// An extension for [TextTheme] in order to complat with flutter2.
extension TextThemeCompat on TextTheme {

  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline4 => headlineLarge;
  TextStyle? get headline5 => headlineMedium;
  TextStyle? get headline6 => headlineSmall;

  TextStyle? get subtitle1 => titleLarge;
  TextStyle? get subtitle2 => titleMedium;

  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;

  TextStyle? get caption => bodySmall;
  TextStyle? get button => labelLarge;
  TextStyle? get overline => labelSmall;

  TextStyle? get subtitle => titleMedium;
}
