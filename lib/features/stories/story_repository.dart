import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/story.dart';

class StoryRepository {
  final ApiClient _api;
  final CacheManager _cache;

  StoryRepository(this._api, this._cache);

  Future<({List<Story> items, int total, int page, int totalPages})>
      getStories({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (category != null) params['category'] = category;
    final response =
        await _api.get(ApiEndpoints.stories, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => Story.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.storyCache, 'list_p$page', jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<Story> getStoryDetail(String slug) async {
    final response = await _api.get(ApiEndpoints.storyDetail(slug));
    return Story.fromJson(response.data);
  }

  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiEndpoints.storyCategories);
    return (response.data as List).cast<String>();
  }
}
