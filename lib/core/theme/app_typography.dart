import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const double bodySize = 18.0;
  static const double titleSize = 24.0;
  static const double largeTitleSize = 34.0;
  static const double captionSize = 14.0;
  static const double lineHeight = 1.8;

  /// Primary Chinese font — Noto Serif SC for all platforms.
  /// A beautiful Song/Ming-style serif that suits Buddhist reading content.
  static const String _primaryFont = 'NotoSerifSC';

  /// Fallback font stack for characters not covered by the primary font.
  static const List<String> _fontFallback = [
    'PingFang SC',
    'Microsoft YaHei',
    'Noto Sans SC',
    'Hiragino Sans GB',
    'WenQuanYi Micro Hei',
    'SimSun',
  ];

  static TextTheme createTextTheme({required bool isDark}) {
    final color = isDark ? AppColors.darkText : AppColors.text;
    final secondaryColor =
        isDark ? AppColors.darkSecondaryText : AppColors.secondaryText;

    return TextTheme(
      // Page titles
      displayLarge: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: largeTitleSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      ),
      // Section / card titles
      headlineMedium: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: titleSize,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      // Sub-headlines (used for list item titles)
      titleMedium: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.5,
      ),
      // Body text (reading)
      bodyLarge: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: bodySize,
        fontWeight: FontWeight.w400,
        color: color,
        height: lineHeight,
      ),
      // Secondary / caption text
      bodyMedium: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: captionSize,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.5,
      ),
      // Labels / chips
      labelMedium: TextStyle(
        fontFamily: _primaryFont,
        fontFamilyFallback: _fontFallback,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.3,
        height: 1.4,
      ),
    );
  }
}
