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
    final response = await _api.get(ApiEndpoints.timeline);
    // API returns a plain array, not a paginated wrapper.
    final list = (response.data as List)
        .map((j) => TimelineEvent.fromJson(j as Map<String, dynamic>))
        .toList();
    await _cache.put(
        HiveBoxes.timelineCache, 'list', jsonEncode(response.data));
    return (
      items: list,
      total: list.length,
      page: 1,
      totalPages: 1,
    );
  }

  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiEndpoints.timeline);
    final items = (response.data as List)
        .map((j) => TimelineEvent.fromJson(j as Map<String, dynamic>))
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
