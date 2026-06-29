import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../favorites/favorites_controller.dart';
import 'sutra_controller.dart';

class SutraDetailPage extends ConsumerWidget {
  final String slug;
  const SutraDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sutra = ref.watch(sutraDetailControllerProvider(slug));
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
                    await ref.read(favoritesProvider.notifier).toggle(
                        'sutra', slug, s.title,
                        subtitle: s.category);
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
            _InfoRow(label: 'CBETA', value: s.cbetaId),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  const _InfoRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 60,
              child:
                  Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}
