import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/timeline_event.dart';

class TimelineRepository {
  final ApiClient _api;
  final CacheManager _cache;

  TimelineRepository(this._api, this._cache);

  Future<({List<TimelineEvent> items, int total, int page, int totalPages})>
      getEvents({
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    if (category != null) params['category'] = category;
    final response =
        await _api.get(ApiEndpoints.timeline, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((j) => TimelineEvent.fromJson(j))
        .toList();
    await _cache.put(
        HiveBoxes.timelineCache, 'list_p$page', jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiEndpoints.timeline,
        queryParameters: {'pageSize': 100});
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((j) => TimelineEvent.fromJson(j))
        .toList();
    final categories = items
        .map((e) => e.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
}
