import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/encyclopedia_entry.dart';
import 'encyclopedia_repository.dart';

final encyclopediaRepositoryProvider = Provider<EncyclopediaRepository>(
    (ref) => EncyclopediaRepository(ref.watch(apiClientProvider), CacheManager()));

// Encyclopedia list controller
final encyclopediaListControllerProvider = AsyncNotifierProvider.family<
    EncyclopediaListController, EncyclopediaListState, String?>(
    () => EncyclopediaListController());

class EncyclopediaListState {
  final List<EncyclopediaEntry> entries;
  final int page;
  final int totalPages;
  final bool isLoadingMore;
  const EncyclopediaListState(
      {this.entries = const [],
      this.page = 1,
      this.totalPages = 1,
      this.isLoadingMore = false});
}

class EncyclopediaListController
    extends FamilyAsyncNotifier<EncyclopediaListState, String?> {
  @override
  Future<EncyclopediaListState> build(String? category) async {
    final repo = ref.read(encyclopediaRepositoryProvider);
    final result = await repo.getEntries(category: category);
    return EncyclopediaListState(
        entries: result.items,
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
    state = AsyncData(EncyclopediaListState(
        entries: current.entries,
        page: current.page,
        totalPages: current.totalPages,
        isLoadingMore: true));
    final repo = ref.read(encyclopediaRepositoryProvider);
    final nextPage = current.page + 1;
    try {
      final result = await repo.getEntries(category: arg, page: nextPage);
      state = AsyncData(EncyclopediaListState(
        entries: [...current.entries, ...result.items],
        page: result.page,
        totalPages: result.totalPages,
      ));
    } catch (_) {
      state = AsyncData(EncyclopediaListState(
        entries: current.entries,
        page: current.page,
        totalPages: current.totalPages,
      ));
    }
  }
}

// Encyclopedia detail controller
final encyclopediaDetailControllerProvider = AsyncNotifierProvider.family<
    EncyclopediaDetailController, EncyclopediaEntry, String>(
    () => EncyclopediaDetailController());

class EncyclopediaDetailController
    extends FamilyAsyncNotifier<EncyclopediaEntry, String> {
  @override
  Future<EncyclopediaEntry> build(String slug) async {
    return ref.read(encyclopediaRepositoryProvider).getEntryDetail(slug);
  }
}

// Categories provider
final encyclopediaCategoriesProvider =
    FutureProvider<List<String>>((ref) async {
  return ref.read(encyclopediaRepositoryProvider).getCategories();
});
