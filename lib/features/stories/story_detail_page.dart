import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../core/theme/theme_provider.dart' show isNightModeProvider;
import '../../shared/models/app_exception.dart';
import '../../shared/widgets/share_poster_button.dart';
import '../favorites/favorites_controller.dart';
import '../history/reading_history_page.dart';
import 'story_controller.dart';

class StoryDetailPage extends ConsumerWidget {
  final String slug;
  const StoryDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final story = ref.watch(storyDetailControllerProvider(slug));
    final isNight = ref.watch(isNightModeProvider);
    ref.listen(storyDetailControllerProvider(slug), (_, next) {
      next.whenOrNull(data: (s) {
        ref.read(readingHistoryRepositoryProvider).addEntry(
              type: 'story', slug: slug, title: s.title);
      });
    });

    return story.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(storyDetailControllerProvider(slug)))),
      data: (s) => Scaffold(
        backgroundColor: isNight
            ? const Color(0xFF1A1A2E)
            : Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(s.title),
          actions: [
            SharePosterButton(
              type: 'story',
              slug: slug,
              title: s.title,
            ),
            Consumer(
              builder: (context, ref, _) {
                final status = ref.watch(
                    favoriteStatusProvider((type: 'story', slug: slug)));
                return IconButton(
                  icon: Icon(status.valueOrNull == true
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: status.valueOrNull == true ? Colors.red : null,
                  onPressed: () async {
                    try {
                      await ref.read(favoritesProvider.notifier).toggle(
                          'story', slug, s.title,
                          subtitle: s.category);
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
            // Image
            if (s.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: s.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const SizedBox(
                      height: 200,
                      child: Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2))),
                  errorWidget: (_, __, ___) => const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.image_outlined))),
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Title
            Text(s.title, style: Theme.of(context).textTheme.displayLarge),
            if (s.titleEn != null) ...[
              const SizedBox(height: 4),
              Text(s.titleEn!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            // Category badge
            Wrap(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A24A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(s.category,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFC9A24A))),
                ),
              ],
            ),
            if (s.sourceSutra != null) ...[
              const SizedBox(height: 8),
              Text('出处：${s.sourceSutra!}',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
            const SizedBox(height: 20),
            // Summary
            if (s.summary.isNotEmpty) ...[
              Text(s.summary,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
            ],
            // Content (full text)
            Text(
              s.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                  ),
            ),
            // Moral quote
            if (s.moral != null && s.moral!.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A24A).withValues(alpha: 0.05),
                  border: const Border(
                    left: BorderSide(
                      color: Color(0xFFC9A24A),
                      width: 3,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote,
                        color: Color(0xFFC9A24A), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.moral!,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFFC9A24A),
                                ),
                      ),
                    ),
                  ],
                ),
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
