import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/cache_manager.dart';
import 'reading_history_repository.dart';

final readingHistoryRepositoryProvider =
    Provider((ref) => ReadingHistoryRepository(ref.watch(cacheManagerProvider)));

final readingHistoryProvider = Provider<List<ReadingHistoryEntry>>((ref) {
  return ref.watch(readingHistoryRepositoryProvider).getAll();
});

class ReadingHistoryPage extends ConsumerWidget {
  const ReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(readingHistoryProvider);
    final grouped = _groupByDate(entries);

    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读历史'),
        actions: entries.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '清除历史',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('清除阅读历史'),
                        content: const Text('确定要清除所有阅读历史吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref
                          .read(readingHistoryRepositoryProvider)
                          .clearAll();
                      ref.invalidate(readingHistoryProvider);
                    }
                  },
                ),
              ]
            : null,
      ),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('暂无阅读历史',
                      style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final group = grouped[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(group.label,
                          style: Theme.of(context).textTheme.labelMedium),
                    ),
                    ...group.entries.map((entry) => ListTile(
                          leading: Icon(_typeIcon(entry.type)),
                          title: Text(entry.title,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(_formatTime(entry.timestamp)),
                          trailing: Text(_typeLabel(entry.type),
                              style: Theme.of(context).textTheme.labelMedium),
                          onTap: () => context.push('/${entry.type}/${entry.slug}'),
                        )),
                  ],
                );
              },
            ),
    );
  }

  IconData _typeIcon(String type) => switch (type) {
        'sutra' => Icons.menu_book,
        'glossary' => Icons.bookmark,
        'story' => Icons.auto_stories,
        'encyclopedia' => Icons.account_balance,
        _ => Icons.article,
      };

  String _typeLabel(String type) => switch (type) {
        'sutra' => '经典',
        'glossary' => '词典',
        'story' => '故事',
        'encyclopedia' => '百科',
        _ => type,
      };

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    return '${t.month}/${t.day} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  List<_DateGroup> _groupByDate(List<ReadingHistoryEntry> entries) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<ReadingHistoryEntry>>{};
    for (final e in entries) {
      final date = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      final label = date == today
          ? '今天'
          : date == yesterday
              ? '昨天'
              : '${date.month}月${date.day}日';
      groups.putIfAbsent(label, () => []).add(e);
    }
    return groups.entries.map((e) => _DateGroup(label: e.key, entries: e.value)).toList();
  }
}

class _DateGroup {
  final String label;
  final List<ReadingHistoryEntry> entries;
  const _DateGroup({required this.label, required this.entries});
}
