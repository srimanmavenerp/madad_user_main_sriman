import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF5D2E95), // Purple
  primaryColorLight: const Color(0xFFF0F4F8),
  primaryColorDark: const Color(0xFF3E2066), // A darker shade of purple (optional)
  secondaryHeaderColor: const Color(0xFFB38937), // Gold

  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  hintColor: const Color(0xFFA4A4A4),
  focusColor: const Color(0xFFFFF9E5),
  hoverColor: const Color(0xFFF8FAFC),
  shadowColor:  const Color(0xFFE6E5E5),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF5D2E95), // Purple for text buttons
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF5D2E95),   // Purple
    secondary: Color(0xFFB38937), // Gold
    onSecondary: Color(0xFFfff3cd), // Optional: a light gold for contrast
    tertiary: Color(0xFFd35221),
    onSecondaryContainer: Color(0xFFB38937), // Gold
    error: Color(0xFFf76767),
    onPrimary: Color(0xFFF8FAFC),
  ).copyWith(surface: const Color(0xffFCFCFC)),
);