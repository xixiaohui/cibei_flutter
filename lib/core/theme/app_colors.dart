// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC9A24A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF111111);
  static const Color text = Color(0xFF000000);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF888888);
  static const Color darkSecondaryText = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color surface = Color(0xFFF8F8F8);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color error = Color(0xFFD32F2F);

  // Light Theme ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: primary,
    onSecondary: Colors.white,
    surface: background,
    onSurface: text,
    error: error,
    onError: Colors.white,
  );

  // Dark Theme ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    secondary: primary,
    onSecondary: Colors.white,
    surface: darkBackground,
    onSurface: darkText,
    error: error,
    onError: Colors.white,
  );
}
