import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/loading_indicator.dart';
import 'path_controller.dart';

class PathListPage extends ConsumerWidget {
  const PathListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pathListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('学习路线')),
      body: state.when(
        data: (data) {
          if (data.paths.isEmpty) {
            return const Center(child: Text('暂无学习路线'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.paths.length,
            itemBuilder: (context, index) {
              final path = data.paths[index];
              return Padding(
                padding: EdgeInsets.only(
                    bottom: index < data.paths.length - 1 ? 12 : 0),
                child: _PathCard(
                  title: path.title,
                  subtitle: path.description,
                  level: path.levelLabel,
                  stepCount: path.stepCount,
                  onTap: () => context.push('/paths/${path.slug}'),
                ),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(pathListControllerProvider),
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String level;
  final int stepCount;
  final VoidCallback onTap;

  const _PathCard({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.stepCount,
    required this.onTap,
  });

  Color _levelColor() {
    switch (level) {
      case '入门':
        return const Color(0xFF4CAF50);
      case '中级':
        return const Color(0xFF2196F3);
      case '高级':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levelColor = _levelColor();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A24A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.route, color: Color(0xFFC9A24A)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: levelColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            level,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: levelColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$stepCount 课',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
