// lib/core/theme/app_typography.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const double bodySize = 18.0;
  static const double titleSize = 24.0;
  static const double largeTitleSize = 34.0;
  static const double captionSize = 14.0;
  static const double lineHeight = 1.8;

  static const String iosFont = 'SF Pro';
  static const String androidFont = 'Noto Sans SC';

  static String get fontFamily {
    return defaultTargetPlatform == TargetPlatform.iOS ? iosFont : androidFont;
  }

  static TextTheme createTextTheme({required bool isDark}) {
    final color = isDark ? AppColors.darkText : AppColors.text;
    final secondaryColor = isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: largeTitleSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: titleSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontSize: bodySize,
        fontWeight: FontWeight.w400,
        color: color,
        height: lineHeight,
      ),
      bodyMedium: TextStyle(
        fontSize: captionSize,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
