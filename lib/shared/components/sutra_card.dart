import 'package:flutter/material.dart';
import '../../shared/models/sutra.dart';

class SutraCard extends StatelessWidget {
  final Sutra sutra;
  final VoidCallback? onTap;
  const SutraCard({super.key, required this.sutra, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '经典: ${sutra.title}',
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sutra.category != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9A24A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      sutra.category!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFC9A24A)),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(sutra.title,
                    style: Theme.of(context).textTheme.headlineMedium),
                if (sutra.translator != null || sutra.dynasty != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    [sutra.dynasty, sutra.translator]
                        .whereType<String>()
                        .join(' · '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (sutra.summary != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    sutra.summary!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
