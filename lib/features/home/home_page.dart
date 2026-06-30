import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../core/widgets/offline_banner.dart';
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
      body: Column(
        children: [
          const OfflineBanner(),
          // ── Header: logo + 慈悲空间 ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '慈悲空间',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: '搜索',
                    onPressed: () => context.push('/search'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
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
                    const SizedBox(height: 16),
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
          ),
        ],
      ),
    );
  }
}
