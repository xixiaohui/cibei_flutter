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
  const TimelineListState({this.events = const []});
}

class TimelineListController
    extends FamilyAsyncNotifier<TimelineListState, String?> {
  @override
  Future<TimelineListState> build(String? category) async {
    final repo = ref.read(timelineRepositoryProvider);
    final result = await repo.getEvents(category: category);
    return TimelineListState(events: result.items);
  }
}

// Categories
final timelineCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(timelineRepositoryProvider).getCategories();
});
