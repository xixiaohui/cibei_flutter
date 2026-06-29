import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fontSizeProvider = StateProvider<double>((ref) => 18.0);
final lineHeightProvider = StateProvider<double>((ref) => 1.8);
final readingWidthProvider = StateProvider<double>((ref) => 1.0);
final isNightModeProvider = StateProvider<bool>((ref) => false);

class ReadingToolbar extends ConsumerWidget {
  const ReadingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border:
            Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.text_decrease),
                onPressed: () =>
                    ref.read(fontSizeProvider.notifier).state =
                        (ref.read(fontSizeProvider) - 2).clamp(14, 34)),
            Text('${ref.watch(fontSizeProvider).toInt()}pt',
                style: Theme.of(context).textTheme.labelMedium),
            IconButton(
                icon: const Icon(Icons.text_increase),
                onPressed: () =>
                    ref.read(fontSizeProvider.notifier).state =
                        (ref.read(fontSizeProvider) + 2).clamp(14, 34)),
            IconButton(
                icon: const Icon(Icons.format_line_spacing),
                onPressed: () =>
                    ref.read(lineHeightProvider.notifier).state =
                        ref.read(lineHeightProvider) == 1.8
                            ? 2.2
                            : ref.read(lineHeightProvider) == 2.2
                                ? 2.6
                                : 1.8),
            IconButton(
              icon: Icon(ref.watch(isNightModeProvider)
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: () => ref.read(isNightModeProvider.notifier).state =
                  !ref.read(isNightModeProvider),
            ),
            IconButton(
                icon: const Icon(Icons.width_normal),
                onPressed: () =>
                    ref.read(readingWidthProvider.notifier).state =
                        ref.read(readingWidthProvider) == 1.0 ? 0.85 : 1.0),
          ],
        ),
      ),
    );
  }
}
