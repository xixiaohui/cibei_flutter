import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/section_header.dart';

class PathListPage extends ConsumerWidget {
  const PathListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('学习路线')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionHeader(title: '系统学习路线', action: null),
          const SizedBox(height: 12),
          _PathCard(
            title: '佛学入门',
            subtitle: '从零开始了解佛教基础知识',
            level: '入门',
            stepCount: 12,
            onTap: () => context.push('/paths/introduction'),
          ),
          const SizedBox(height: 12),
          _PathCard(
            title: '经典研读',
            subtitle: '深入学习重要佛经文本',
            level: '中级',
            stepCount: 24,
            onTap: () => context.push('/paths/sutra-study'),
          ),
          const SizedBox(height: 12),
          _PathCard(
            title: '禅修实践',
            subtitle: '从理论到实践的禅修指导',
            level: '高级',
            stepCount: 16,
            onTap: () => context.push('/paths/meditation'),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Chip(label: Text(level, style: const TextStyle(fontSize: 12))),
                        const SizedBox(width: 8),
                        Text('$stepCount课', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
