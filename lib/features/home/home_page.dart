import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/components/sutra_card.dart';
import 'home_controller.dart';
import 'widgets/today_sutra_card.dart';
import 'widgets/story_carousel.dart';
import 'widgets/learning_path_section.dart';
import 'widgets/popular_terms_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cibei Space')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (err, st) => ErrorDisplay(
            message: err.toString(),
            onRetry: () => ref.invalidate(homeControllerProvider)),
        data: (home) => RefreshIndicator(
          onRefresh: () =>
              ref.read(homeControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 8),
              // Today's Sutra (first sutra as hero)
              if (home.sutras.isNotEmpty)
                TodaySutraCard(sutra: home.sutras.first),
              const SizedBox(height: 24),
              // Recent Sutras
              if (home.sutras.length > 1) ...[
                const SectionHeader(title: '经典浏览'),
                ...home.sutras.skip(1).map((s) => SutraCard(
                      sutra: s,
                      onTap: () => context.push('/sutra/${s.slug}'),
                    )),
              ],
              const SizedBox(height: 24),
              // Learning Paths
              LearningPathSection(paths: home.paths),
              const SizedBox(height: 24),
              // Stories
              if (home.stories.isNotEmpty) ...[
                const SectionHeader(title: '佛经故事'),
                StoryCarousel(stories: home.stories),
              ],
              const SizedBox(height: 24),
              // Popular Terms
              PopularTermsSection(terms: home.terms),
            ],
          ),
        ),
      ),
    );
  }
}
