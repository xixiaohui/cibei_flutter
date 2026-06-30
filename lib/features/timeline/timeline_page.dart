import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../shared/models/timeline_event.dart';
import 'timeline_controller.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timelineListControllerProvider(null));
    final categoriesAsync = ref.watch(timelineCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('佛教时间线')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(timelineListControllerProvider(null)),
        ),
        data: (data) {
          final allEvents = data.events;
          if (allEvents.isEmpty) {
            return const Center(child: Text('暂无数据'));
          }

          // Sort chronologically (negative years = BCE come first)
          final sorted = List<TimelineEvent>.from(allEvents)
            ..sort((a, b) => a.year.compareTo(b.year));

          // Apply category filter
          final filtered = _selectedCategory == null
              ? sorted
              : sorted.where((e) => e.category == _selectedCategory).toList();

          return Column(
            children: [
              // Category filter chips
              categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final selected = _selectedCategory == null;
                            return FilterChip(
                              label: const Text('全部'),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = null),
                              showCheckmark: false,
                            );
                          }
                          final cat = categories[index - 1];
                          final selected = _selectedCategory == cat;
                          return FilterChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (_) => setState(
                                () => _selectedCategory = selected ? null : cat),
                            showCheckmark: false,
                            selectedColor:
                                _categoryColor(cat).withValues(alpha: 0.15),
                          );
                        },
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),

              // Event count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      '共 ${filtered.length} 个事件',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Timeline list
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('该分类下暂无事件'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final event = filtered[index];
                          final isFirst = index == 0;
                          final isLast = index == filtered.length - 1;
                          return _TimelineNode(
                            year: event.yearDisplay,
                            title: event.title,
                            description: event.description,
                            category: event.category,
                            location: event.location,
                            isFirst: isFirst,
                            isLast: isLast,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _categoryColor(String category) => switch (category) {
        '人物' => const Color(0xFF4A90D9),
        '经典译出' => const Color(0xFFC9A24A),
        '宗派创立' => const Color(0xFF5B8C5A),
        '历史事件' => const Color(0xFFE85D3A),
        '圣地' => const Color(0xFF9B59B6),
        _ => Colors.grey,
      };
}

class _TimelineNode extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final String category;
  final String? location;
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({
    required this.year,
    required this.title,
    required this.description,
    required this.category,
    this.location,
    this.isFirst = false,
    this.isLast = false,
  });

  Color _categoryColor(String category) => switch (category) {
        '人物' => const Color(0xFF4A90D9),
        '经典译出' => const Color(0xFFC9A24A),
        '宗派创立' => const Color(0xFF5B8C5A),
        '历史事件' => const Color(0xFFE85D3A),
        '圣地' => const Color(0xFF9B59B6),
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = _categoryColor(category);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 72,
            child: Column(
              children: [
                if (!isFirst) const SizedBox(height: 4),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: dotColor.withValues(alpha: 0.3), width: 3),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: dotColor.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year
                  Text(
                    year,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: dotColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: dotColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                          fontSize: 11,
                          color: dotColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  // Location
                  if (location != null && location!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Description
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.7,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
