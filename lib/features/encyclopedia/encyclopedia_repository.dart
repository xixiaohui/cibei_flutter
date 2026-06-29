import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/encyclopedia_entry.dart';

class EncyclopediaRepository {
  final ApiClient _api;
  final CacheManager _cache;

  EncyclopediaRepository(this._api, this._cache);

  Future<({List<EncyclopediaEntry> items, int total, int page, int totalPages})>
      getEntries({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (category != null) params['category'] = category;
    final response =
        await _api.get(ApiEndpoints.encyclopedia, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((j) => EncyclopediaEntry.fromJson(j))
        .toList();
    final cacheKey = 'list_${category ?? 'all'}_p$page';
    await _cache.put(
        HiveBoxes.storyCache, cacheKey, jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<EncyclopediaEntry> getEntryDetail(String slug) async {
    final response =
        await _api.get(ApiEndpoints.encyclopediaDetail(slug));
    return EncyclopediaEntry.fromJson(response.data);
  }

  Future<List<String>> getCategories() async {
    final response =
        await _api.get(ApiEndpoints.encyclopediaCategories);
    return (response.data as List).cast<String>();
  }
}
