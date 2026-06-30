import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../favorites/favorites_controller.dart';
import '../history/reading_history_repository.dart';
import '../history/reading_history_page.dart';
import '../notes/notes_controller.dart';

class LearningStatsPage extends ConsumerWidget {
  const LearningStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(readingHistoryProvider);
    final favorites = ref.watch(favoritesProvider);
    final notes = ref.watch(notesProvider);

    // Compute stats
    final totalReads = history.length;
    final uniqueReads = history.map((e) => '${e.type}:${e.slug}').toSet().length;
    final streakDays = _computeStreak(history);
    final favoritesCount = favorites.valueOrNull?.length ?? 0;
    final notesCount = notes.valueOrNull?.length ?? 0;

    // Types breakdown
    final typeCounts = <String, int>{};
    for (final e in history) {
      typeCounts[e.type] = (typeCounts[e.type] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('学习统计')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards row
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      icon: Icons.menu_book,
                      label: '累计阅读',
                      value: '$totalReads',
                      color: const Color(0xFF4A90D9))),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.auto_stories,
                      label: '阅读篇目',
                      value: '$uniqueReads',
                      color: const Color(0xFFC9A24A))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      icon: Icons.local_fire_department,
                      label: '连续打卡',
                      value: '$streakDays 天',
                      color: const Color(0xFFE85D3A))),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      icon: Icons.favorite,
                      label: '我的收藏',
                      value: '$favoritesCount',
                      color: const Color(0xFFE04060))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      icon: Icons.edit_note,
                      label: '我的笔记',
                      value: '$notesCount',
                      color: const Color(0xFF5B8C5A))),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          if (typeCounts.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text('阅读分布', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...typeCounts.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(_typeLabel(e.key),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: totalReads > 0
                                ? e.value / totalReads
                                : 0,
                            minHeight: 8,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 30,
                        child: Text('${e.value}',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  String _typeLabel(String type) => switch (type) {
        'sutra' => '经典',
        'glossary' => '词典',
        'story' => '故事',
        'encyclopedia' => '百科',
        _ => type,
      };

  /// Count consecutive days backwards from today
  int _computeStreak(List<ReadingHistoryEntry> entries) {
    if (entries.isEmpty) return 0;
    final days = entries.map((e) {
      final t = e.timestamp;
      return DateTime(t.year, t.month, t.day);
    }).toSet().toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Must have read today to start streak
    if (days.first != todayStart) return 0;

    int streak = 1;
    for (int i = 1; i < days.length; i++) {
      if (days[i - 1].difference(days[i]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
