import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/models/app_exception.dart';
import '../../shared/models/sutra.dart';
import '../../shared/widgets/share_poster_button.dart';
import '../favorites/favorites_controller.dart';
import '../history/reading_history_page.dart';
import 'sutra_controller.dart';

class SutraDetailPage extends ConsumerWidget {
  final String slug;
  const SutraDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sutra = ref.watch(sutraDetailControllerProvider(slug));
    ref.listen(sutraDetailControllerProvider(slug), (_, next) {
      next.whenOrNull(data: (s) {
        ref.read(readingHistoryRepositoryProvider).addEntry(
              type: 'sutra', slug: slug, title: s.title);
      });
    });
    return sutra.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (err, _) => Scaffold(
          body: ErrorDisplay(
              message: err.toString(),
              onRetry: () =>
                  ref.invalidate(sutraDetailControllerProvider(slug)))),
      data: (s) => Scaffold(
        appBar: AppBar(
          title: Text(s.title),
          actions: [
            SharePosterButton(type: 'sutra', slug: slug, title: s.title),
            Consumer(
              builder: (context, ref, _) {
                final status = ref.watch(
                    favoriteStatusProvider((type: 'sutra', slug: slug)));
                return IconButton(
                  icon: Icon(status.valueOrNull == true
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: status.valueOrNull == true ? Colors.red : null,
                  onPressed: () async {
                    try {
                      await ref.read(favoritesProvider.notifier).toggle(
                          'sutra', slug, s.title,
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
            Text(s.title, style: Theme.of(context).textTheme.displayLarge),
            if (s.titleEn != null) ...[
              const SizedBox(height: 4),
              Text(s.titleEn!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 20),
            _InfoRow(label: '朝代', value: s.dynasty),
            _InfoRow(label: '译者', value: s.translator),
            _InfoRow(label: '分类', value: s.category),
            _InfoRow(
              label: 'CBETA',
              value: s.cbetaId,
              onTap: () async {
                final url = sutraSourceUrl(s);
                if (url != null) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                }
              },
            ),
            if (s.summary != null) ...[
              const SizedBox(height: 20),
              Text(s.summary!,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/sutra/$slug/read'),
              icon: const Icon(Icons.menu_book),
              label: const Text('开始阅读'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFFC9A24A),
              ),
            ),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;
  const _InfoRow({required this.label, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    final row = Row(
      children: [
        SizedBox(
            width: 60,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(child: Text(value!)),
        if (onTap != null)
          Icon(Icons.open_in_new,
              size: 16, color: Theme.of(context).colorScheme.primary),
      ],
    );

    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: row,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: row,
        ),
      ),
    );
  }
}
