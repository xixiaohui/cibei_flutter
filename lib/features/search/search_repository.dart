import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/search_result.dart';

class SearchRepository {
  final ApiClient _api;
  final CacheManager _cache;

  SearchRepository(this._api, this._cache);

  Future<SearchResponse> search(String query, {String? type}) async {
    final params = <String, dynamic>{'q': query};
    if (type != null) params['type'] = type;
    final response =
        await _api.get(ApiEndpoints.search, queryParameters: params);
    return SearchResponse.fromJson(response.data);
  }

  Future<List<String>> getRecentSearches() async {
    return _cache.get<List>(HiveBoxes.searchHistory, 'recent')?.cast<String>() ??
        [];
  }

  Future<void> saveRecentSearch(String query) async {
    var recent = await getRecentSearches();
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > 50) recent = recent.sublist(0, 50);
    await _cache.put(HiveBoxes.searchHistory, 'recent', recent);
  }

  Future<void> clearRecentSearches() async {
    await _cache.delete(HiveBoxes.searchHistory, 'recent');
  }
}
