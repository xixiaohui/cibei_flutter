import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/glossary_term.dart';

class DictionaryRepository {
  final ApiClient _api;
  final CacheManager _cache;

  DictionaryRepository(this._api, this._cache);

  Future<({List<GlossaryTerm> items, int total, int page, int totalPages})>
      getTerms({
    String? letter,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (letter != null) params['letter'] = letter;
    final response =
        await _api.get(ApiEndpoints.glossary, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((j) => GlossaryTerm.fromJson(j))
        .toList();
    await _cache.put(
        HiveBoxes.glossaryCache, 'list_p$page', jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<GlossaryTerm> getTermDetail(String slug) async {
    final response = await _api.get(ApiEndpoints.glossaryDetail(slug));
    return GlossaryTerm.fromJson(response.data);
  }
}
