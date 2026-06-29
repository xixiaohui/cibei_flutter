import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/story.dart';
import 'story_repository.dart';

final storyRepositoryProvider =
    Provider((ref) => StoryRepository(ApiClient(), CacheManager()));

// Story list controller
final storyListControllerProvider = AsyncNotifierProvider.family<
    StoryListController, StoryListState, String?>(() => StoryListController());

class StoryListState {
  final List<Story> stories;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const StoryListState(
      {this.stories = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class StoryListController extends FamilyAsyncNotifier<StoryListState, String?> {
  @override
  Future<StoryListState> build(String? category) async {
    final repo = ref.read(storyRepositoryProvider);
    final result = await repo.getStories(category: category);
    return StoryListState(
        stories: result.items,
        page: result.page,
        totalPages: result.totalPages);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.isLoadingMore ||
        current.page >= current.totalPages) {
      return;
    }
    state = AsyncData(StoryListState(
        stories: current.stories,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(storyRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repo.getStories(category: arg, page: nextPage);
    state = AsyncData(StoryListState(
      stories: [...current.stories, ...result.items],
      page: result.page,
      totalPages: result.totalPages,
    ));
  }
}

// Story detail controller
final storyDetailControllerProvider =
    AsyncNotifierProvider.family<StoryDetailController, Story, String>(
        () => StoryDetailController());

class StoryDetailController extends FamilyAsyncNotifier<Story, String> {
  @override
  Future<Story> build(String slug) async {
    return ref.read(storyRepositoryProvider).getStoryDetail(slug);
  }
}

// Categories
final storyCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(storyRepositoryProvider).getCategories();
});
