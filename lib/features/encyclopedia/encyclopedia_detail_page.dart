import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'encyclopedia_controller.dart';

class EncyclopediaDetailPage extends ConsumerWidget {
  final String slug;
  const EncyclopediaDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(encyclopediaDetailControllerProvider(slug));
    return entry.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(encyclopediaDetailControllerProvider(slug)))),
      data: (e) => Scaffold(
        appBar: AppBar(title: Text(e.title)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (e.category != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  e.category!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(e.title, style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 24),
            Text(e.content,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
