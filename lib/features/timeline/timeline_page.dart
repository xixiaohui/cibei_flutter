import 'package:flutter/material.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('佛教时间线')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _TimelineNode(
            year: '公元前6世纪',
            title: '释迦牟尼诞生',
            description: '佛陀诞生于古印度迦毗罗卫国',
            isFirst: true,
          ),
          _TimelineNode(
            year: '公元前5世纪',
            title: '成道与初转法轮',
            description: '佛陀在菩提树下悟道，于鹿野苑初转法轮',
          ),
          _TimelineNode(
            year: '约公元前483年',
            title: '佛陀涅槃',
            description: '佛陀在拘尸那揭罗入灭',
          ),
          _TimelineNode(
            year: '约公元前3世纪',
            title: '阿育王弘法',
            description: '阿育王皈依佛教，推动佛教向外传播',
          ),
          _TimelineNode(
            year: '公元1世纪',
            title: '大乘佛教兴起',
            description: '大乘佛教思想开始形成并传播',
          ),
          _TimelineNode(
            year: '公元1世纪左右',
            title: '佛教传入中国',
            description: '佛教经由丝绸之路传入中国',
          ),
          _TimelineNode(
            year: '公元5-6世纪',
            title: '禅宗创立',
            description: '达摩东来，禅宗在中国逐渐形成',
          ),
          _TimelineNode(
            year: '公元7世纪',
            title: '玄奘西行',
            description: '玄奘法师赴印度取经，翻译大量佛经',
            isLast: true,
          ),
        ],
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
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
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(year,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFC9A24A),
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 4),
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
