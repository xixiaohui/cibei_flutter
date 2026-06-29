import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/cache_manager.dart';
import '../../shared/models/search_result.dart';
import 'search_repository.dart';

final searchRepositoryProvider = Provider(
  (ref) => SearchRepository(ref.watch(apiClientProvider), CacheManager()),
);

final searchResultsProvider =
    AsyncNotifierProvider.family<SearchNotifier, SearchResponse, String>(
  () => SearchNotifier(),
);

class SearchNotifier extends FamilyAsyncNotifier<SearchResponse, String> {
  @override
  Future<SearchResponse> build(String query) async {
    if (query.isEmpty) {
      return const SearchResponse(results: [], total: 0);
    }
    final repo = ref.read(searchRepositoryProvider);
    await repo.saveRecentSearch(query);
    return repo.search(query);
  }
}

final recentSearchesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(searchRepositoryProvider).getRecentSearches();
});
