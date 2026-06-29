import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/search_result.dart';
import 'search_repository.dart';

final searchRepositoryProvider = Provider(
  (ref) => SearchRepository(ApiClient(), CacheManager()),
);

final searchResultsProvider =
    StateNotifierProvider.family<SearchNotifier, AsyncValue<SearchResponse>, String>(
  (ref, query) {
    return SearchNotifier(ref, query);
  },
);

class SearchNotifier extends StateNotifier<AsyncValue<SearchResponse>> {
  final Ref _ref;
  final String _query;

  SearchNotifier(this._ref, this._query) : super(const AsyncLoading()) {
    _search();
  }

  Future<void> _search() async {
    if (_query.isEmpty) {
      state = const AsyncData(SearchResponse(results: [], total: 0));
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = _ref.read(searchRepositoryProvider);
      await repo.saveRecentSearch(_query);
      return repo.search(_query);
    });
  }
}

final recentSearchesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(searchRepositoryProvider).getRecentSearches();
});
