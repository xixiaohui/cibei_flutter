import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import 'dictionary_controller.dart';

class DictionaryDetailPage extends ConsumerWidget {
  final String slug;
  const DictionaryDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(dictionaryDetailControllerProvider(slug));
    return term.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(dictionaryDetailControllerProvider(slug)))),
      data: (t) => Scaffold(
        appBar: AppBar(title: Text(t.term)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(t.term, style: Theme.of(context).textTheme.displayLarge),
            if (t.termEn != null) ...[
              const SizedBox(height: 4),
              Text(t.termEn!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (t.termSanskrit != null) ...[
              const SizedBox(height: 4),
              Text(t.termSanskrit!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      )),
            ],
            const SizedBox(height: 24),
            Text(t.definition,
                style: Theme.of(context).textTheme.bodyLarge),
            if (t.relatedTerms.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('相关词条',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: t.relatedTerms.map((related) {
                  return ActionChip(
                    label: Text(related),
                    onPressed: () =>
                        context.push('/glossary/$related'),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
