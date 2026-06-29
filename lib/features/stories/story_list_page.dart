import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_display.dart';
import '../../shared/components/story_card.dart';
import 'story_controller.dart';

class StoryListPage extends ConsumerStatefulWidget {
  const StoryListPage({super.key});

  @override
  ConsumerState<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends ConsumerState<StoryListPage> {
  String? _selectedCategory;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(storyListControllerProvider(_selectedCategory).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyListControllerProvider(_selectedCategory));
    final categories = ref.watch(storyCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('佛教故事')),
      body: Column(
        children: [
          // Category filter
          categories.when(
            data: (cats) => SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cats.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final cat = isAll ? null : cats[index - 1];
                  final isSelected = _selectedCategory == cat;
                  return FilterChip(
                    label: Text(isAll ? '全部' : cat!),
                    selected: isSelected,
                    onSelected: (_) {
                      _scrollController.jumpTo(0);
                      setState(() => _selectedCategory = cat);
                    },
                  );
                },
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (err, _) => ErrorDisplay(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(
                      storyListControllerProvider(_selectedCategory))),
              data: (data) => RefreshIndicator(
                onRefresh: () async => ref.invalidate(
                    storyListControllerProvider(_selectedCategory)),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  itemCount:
                      data.stories.length + (data.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= data.stories.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child:
                                CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    final story = data.stories[index];
                    return StoryCard(
                        story: story,
                        onTap: () => context.push('/story/${story.slug}'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
