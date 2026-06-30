import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/models/app_exception.dart';
import '../../shared/widgets/share_poster_button.dart';
import '../favorites/favorites_controller.dart';
import '../history/reading_history_page.dart';
import 'encyclopedia_controller.dart';

class EncyclopediaDetailPage extends ConsumerWidget {
  final String slug;
  const EncyclopediaDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(encyclopediaDetailControllerProvider(slug));
    ref.listen(encyclopediaDetailControllerProvider(slug), (_, next) {
      next.whenOrNull(data: (e) {
        ref.read(readingHistoryRepositoryProvider).addEntry(
              type: 'encyclopedia', slug: slug, title: e.title);
      });
    });
    return entry.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(encyclopediaDetailControllerProvider(slug)))),
      data: (e) => Scaffold(
        appBar: AppBar(
          title: Text(e.title),
          actions: [
            SharePosterButton(
              type: 'encyclopedia',
              slug: slug,
              title: e.title,
            ),
            Consumer(
              builder: (context, ref, _) {
                final status = ref.watch(
                    favoriteStatusProvider((type: 'encyclopedia', slug: slug)));
                return IconButton(
                  icon: Icon(status.valueOrNull == true
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: status.valueOrNull == true ? Colors.red : null,
                  onPressed: () async {
                    try {
                      await ref.read(favoritesProvider.notifier).toggle(
                          'encyclopedia', slug, e.title,
                          subtitle: e.category);
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
