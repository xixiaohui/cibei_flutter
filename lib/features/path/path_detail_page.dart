import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/loading_indicator.dart';
import 'path_controller.dart';

class PathDetailPage extends ConsumerWidget {
  final String slug;
  const PathDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pathDetailControllerProvider(slug));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('学习路线')),
      body: state.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A24A)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            data.path.levelLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC9A24A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${data.steps.length} 个步骤',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.path.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        height: 1.3,
                      ),
                    ),
                    if (data.path.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        data.path.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.75,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '学习步骤',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...data.steps.map((step) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFC9A24A)
                                .withValues(alpha: 0.1),
                            radius: 18,
                            child: Text(
                              '${step.stepNumber}',
                              style: const TextStyle(
                                color: Color(0xFFC9A24A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              step.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (step.description != null &&
                          step.description!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          step.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ],
                      if (step.guidance != null &&
                          step.guidance!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9A24A)
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  size: 16, color: Color(0xFFC9A24A)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  step.guidance!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    height: 1.5,
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
            }),
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(pathDetailControllerProvider(slug)),
        ),
      ),
    );
  }
}
