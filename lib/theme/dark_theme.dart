import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF5D2E95), // Purple
  primaryColorLight: const Color(0xFFB38937), // Gold (optional for contrast)
  primaryColorDark: const Color(0xFF3E2066), // Darker purple (optional)
  secondaryHeaderColor: const Color(0xFFB38937), // Gold
  disabledColor: const Color(0xFF8797AB),
  scaffoldBackgroundColor: const Color(0xFF151515),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFC0BFBF),
  focusColor: const Color(0xFF484848),
  hoverColor: const Color(0x405D2E95), // Purple with opacity
  shadowColor: const Color(0x335D2E95), // Purple with opacity
  cardColor: const Color(0xFF22223A),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFFB38937)), // Gold for text buttons
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF5D2E95),   // Purple
    secondary: Color(0xFFB38937), // Gold
    onSecondary: Color(0xFFfff3cd), // Optional: a light gold for contrast
    onSecondaryContainer: Color(0xFFB38937), // Gold
    tertiary: Color(0xFFd35221),
    error: Color(0xFFBC4040),
    onPrimary: Color(0xFFF8FAFC),
  ).copyWith(surface: const Color(0xff151515)),
);