// lib/features/ai/widgets/ai_disclaimer.dart
import 'package:flutter/material.dart';

class AiDisclaimer extends StatelessWidget {
  const AiDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFC9A24A).withValues(alpha: 0.08),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Color(0xFFC9A24A)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI 内容仅供学习参考，不代表佛法权威解释',
              style: TextStyle(fontSize: 12, color: Color(0xFFC9A24A)),
            ),
          ),
        ],
      ),
    );
  }
}
