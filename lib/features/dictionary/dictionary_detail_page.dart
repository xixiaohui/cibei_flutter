import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/models/app_exception.dart';
import '../../shared/widgets/share_poster_button.dart';
import '../favorites/favorites_controller.dart';
import '../history/reading_history_page.dart';
import 'dictionary_controller.dart';

class DictionaryDetailPage extends ConsumerWidget {
  final String slug;
  const DictionaryDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(dictionaryDetailControllerProvider(slug));
    final termSlugMap = ref.watch(termSlugMapProvider);
    ref.listen(dictionaryDetailControllerProvider(slug), (_, next) {
      next.whenOrNull(data: (t) {
        ref.read(readingHistoryRepositoryProvider).addEntry(
              type: 'glossary', slug: slug, title: t.term);
      });
    });
    return term.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(dictionaryDetailControllerProvider(slug)))),
      data: (t) => Scaffold(
        appBar: AppBar(
          title: Text(t.term),
          actions: [
            SharePosterButton(
              type: 'dictionary',
              slug: slug,
              title: t.term,
            ),
            Consumer(
              builder: (context, ref, _) {
                final status = ref.watch(
                    favoriteStatusProvider((type: 'glossary', slug: slug)));
                return IconButton(
                  icon: Icon(status.valueOrNull == true
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: status.valueOrNull == true ? Colors.red : null,
                  onPressed: () async {
                    try {
                      await ref.read(favoritesProvider.notifier).toggle(
                          'glossary', slug, t.term);
                    } on Exception {
                      if (context.mounted) {
                        _showLoginTip(context);
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
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
                  final resolvedSlug = termSlugMap.valueOrNull?[related] ?? related;
                  return ActionChip(
                    label: Text(related),
                    onPressed: () =>
                        context.push('/glossary/${Uri.encodeComponent(resolvedSlug)}'),
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

void _showLoginTip(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('需要登录'),
      content: const Text('收藏功能需要登录后才能使用'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/login');
          },
          child: const Text('去登录'),
        ),
      ],
    ),
  );
}
