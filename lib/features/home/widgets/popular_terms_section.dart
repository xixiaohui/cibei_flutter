import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/glossary_term.dart';
import '../../../core/widgets/section_header.dart';

class PopularTermsSection extends StatelessWidget {
  final List<GlossaryTerm> terms;
  const PopularTermsSection({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '热门词条'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: terms
                .map((term) => ActionChip(
                      label: Text(term.term),
                      onPressed: () =>
                          context.push('/glossary/${term.slug}'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
