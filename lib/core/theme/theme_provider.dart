// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final isNightModeProvider = StateProvider<bool>((ref) => false);

// Reading preferences
final fontSizeProvider = StateProvider<double>((ref) => 18.0);
final lineHeightProvider = StateProvider<double>((ref) => 1.8);
final readingWidthProvider = StateProvider<double>((ref) => 1.0);
