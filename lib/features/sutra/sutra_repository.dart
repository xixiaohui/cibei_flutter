import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/sutra_content.dart';

class SutraRepository {
  final ApiClient _api;
  final CacheManager _cache;

  SutraRepository(this._api, this._cache);

  Future<({List<Sutra> items, int total, int page, int totalPages})> getSutras({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (category != null) params['category'] = category;
    final response =
        await _api.get(ApiEndpoints.sutras, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => Sutra.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.sutraCache, 'list_p$page', jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<Sutra> getSutraDetail(String slug) async {
    final response = await _api.get(ApiEndpoints.sutraDetail(slug));
    return Sutra.fromJson(response.data);
  }

  Future<SutraContent> getSutraContent(String slug) async {
    final response = await _api.get(ApiEndpoints.sutraContent(slug));
    final content = SutraContent.fromJson(response.data);
    await _cache.put(
        HiveBoxes.sutraContentCache, slug, jsonEncode(response.data));
    return content;
  }

  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiEndpoints.sutraCategories);
    return (response.data as List).cast<String>();
  }
}
