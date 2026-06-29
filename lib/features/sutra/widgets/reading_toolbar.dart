import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';

final fontSizeProvider = StateProvider<double>((ref) => 18.0);
final lineHeightProvider = StateProvider<double>((ref) => 1.8);
final readingWidthProvider = StateProvider<double>((ref) => 1.0);

class ReadingToolbar extends ConsumerWidget {
  const ReadingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNightMode = ref.watch(isNightModeProvider);
    final isDark = isNightMode;
    final bgColor =
        isDark ? const Color(0xFF1E1E1E) : Theme.of(context).colorScheme.surface;
    final fgColor =
        isDark ? Colors.white70 : Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border:
            Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Semantics(
              label: '减小字体',
              child: IconButton(
                  icon: Icon(Icons.text_decrease, color: fgColor),
                  onPressed: () =>
                      ref.read(fontSizeProvider.notifier).state =
                          (ref.read(fontSizeProvider) - 2).clamp(14, 34)),
            ),
            Semantics(
              label: '字体大小: ${ref.watch(fontSizeProvider).toInt()}pt',
              child: Text('${ref.watch(fontSizeProvider).toInt()}pt',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: fgColor) ??
                      TextStyle(color: fgColor)),
            ),
            Semantics(
              label: '增大字体',
              child: IconButton(
                  icon: Icon(Icons.text_increase, color: fgColor),
                  onPressed: () =>
                      ref.read(fontSizeProvider.notifier).state =
                          (ref.read(fontSizeProvider) + 2).clamp(14, 34)),
            ),
            Semantics(
              label: '调整行间距',
              child: IconButton(
                  icon: Icon(Icons.format_line_spacing, color: fgColor),
                  onPressed: () =>
                      ref.read(lineHeightProvider.notifier).state =
                          ref.read(lineHeightProvider) == 1.8
                              ? 2.2
                              : ref.read(lineHeightProvider) == 2.2
                                  ? 2.6
                                  : 1.8),
            ),
            Semantics(
              label: isNightMode ? '切换到日间模式' : '切换到夜间模式',
              child: IconButton(
                icon: Icon(
                  isNightMode ? Icons.light_mode : Icons.dark_mode,
                  color: fgColor,
                ),
                onPressed: () => ref.read(isNightModeProvider.notifier).state =
                    !ref.read(isNightModeProvider),
              ),
            ),
            Semantics(
              label: '切换阅读宽度',
              child: IconButton(
                  icon: Icon(Icons.width_normal, color: fgColor),
                  onPressed: () =>
                      ref.read(readingWidthProvider.notifier).state =
                          ref.read(readingWidthProvider) == 1.0 ? 0.85 : 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
