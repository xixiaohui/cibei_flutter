import 'package:flutter/material.dart';

class PathDetailPage extends StatelessWidget {
  final String slug;
  const PathDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('学习路线: $slug')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('学习路线',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 12),
                  Text(
                    '本学习路线将引导您系统化地学习佛学知识。每个步骤包含相关的经文阅读、术语解释和指导说明。',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final stepNumber = index + 1;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFC9A24A),
                  child: Text('$stepNumber',
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text('步骤 $stepNumber'),
                subtitle: const Text('内容即将上线'),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          }),
        ],
      ),
    );
  }
}
