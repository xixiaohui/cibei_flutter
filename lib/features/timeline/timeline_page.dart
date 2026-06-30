import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/loading_indicator.dart';
import 'timeline_controller.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timelineListControllerProvider(null));

    return Scaffold(
      appBar: AppBar(title: const Text('佛教时间线')),
      body: state.when(
        data: (data) {
          if (data.events.isEmpty) {
            return const Center(child: Text('暂无数据'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: data.events.length,
            itemBuilder: (context, index) {
              final event = data.events[index];
              final isFirst = index == 0;
              final isLast = index == data.events.length - 1;
              return _TimelineNode(
                year: event.yearDisplay,
                title: event.title,
                description: event.description,
                isFirst: isFirst,
                isLast: isLast,
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(timelineListControllerProvider(null)),
        ),
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({
    required this.year,
    required this.title,
    required this.description,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Column(
              children: [
                if (!isFirst) const SizedBox(height: 4),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A24A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFC9A24A).withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFC9A24A),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.65,
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
