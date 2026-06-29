import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/sutra.dart';

class TodaySutraCard extends StatelessWidget {
  final Sutra sutra;
  const TodaySutraCard({super.key, required this.sutra});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/sutra/${sutra.slug}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFC9A24A).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日经典',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFC9A24A),
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(sutra.title,
                style: Theme.of(context).textTheme.displayLarge),
            if (sutra.summary != null) ...[
              const SizedBox(height: 12),
              Text(
                sutra.summary!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
