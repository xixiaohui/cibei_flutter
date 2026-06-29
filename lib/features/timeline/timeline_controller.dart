import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/timeline_event.dart';
import 'timeline_repository.dart';

final timelineRepositoryProvider =
    Provider((ref) => TimelineRepository(ref.watch(apiClientProvider), CacheManager()));

// Timeline list controller
final timelineListControllerProvider = AsyncNotifierProvider.family<
    TimelineListController, TimelineListState, String?>(() => TimelineListController());

class TimelineListState {
  final List<TimelineEvent> events;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const TimelineListState(
      {this.events = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class TimelineListController
    extends FamilyAsyncNotifier<TimelineListState, String?> {
  @override
  Future<TimelineListState> build(String? category) async {
    final repo = ref.read(timelineRepositoryProvider);
    final result = await repo.getEvents(category: category);
    return TimelineListState(
        events: result.items,
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
    state = AsyncData(TimelineListState(
        events: current.events,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(timelineRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repo.getEvents(category: arg, page: nextPage);
    state = AsyncData(TimelineListState(
      events: [...current.events, ...result.items],
      page: result.page,
      totalPages: result.totalPages,
    ));
  }
}

// Categories
final timelineCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(timelineRepositoryProvider).getCategories();
});
