import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/learning_path.dart';
import '../../../core/widgets/section_header.dart';

class LearningPathSection extends StatelessWidget {
  final List<LearningPath> paths;
  const LearningPathSection({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    if (paths.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '学习路线', action: '查看全部'),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: paths.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final path = paths[index];
              return GestureDetector(
                onTap: () => context.push('/paths/${path.slug}'),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(path.icon,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          path.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${path.levelLabel} · ${path.stepCount}课',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
