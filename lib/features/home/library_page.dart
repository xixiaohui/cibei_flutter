import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('文库')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _LibraryCard(
            icon: Icons.menu_book,
            title: '经典文库',
            subtitle: '浏览佛经原文，支持全文阅读',
            onTap: () => context.push('/sutras'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.bookmark,
            title: '佛学词典',
            subtitle: '查阅佛教术语与概念',
            onTap: () => context.push('/glossary'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.account_balance,
            title: '佛学百科',
            subtitle: '人物、宗派、历史知识',
            onTap: () => context.push('/encyclopedia'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.timeline,
            title: '佛教时间线',
            subtitle: '纵观佛教历史发展',
            onTap: () => context.push('/timeline'),
          ),
          const SizedBox(height: 12),
          _LibraryCard(
            icon: Icons.route,
            title: '学习路线',
            subtitle: '系统化学习佛学知识',
            onTap: () => context.push('/paths'),
          ),
        ],
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '文库: $title',
      button: true,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, size: 32, color: const Color(0xFFC9A24A)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
