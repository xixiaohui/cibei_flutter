import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/learning_path.dart';
import '../../shared/models/path_step.dart';

class PathRepository {
  final ApiClient _api;
  final CacheManager _cache;

  PathRepository(this._api, this._cache);

  Future<({List<LearningPath> items, int total, int page, int totalPages})>
      getPaths({
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'pageSize': pageSize};
    final response =
        await _api.get(ApiEndpoints.paths, queryParameters: params);
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => LearningPath.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.pathCache, 'list_p$page', jsonEncode(data['items']));
    return (
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      totalPages: data['totalPages'] as int
    );
  }

  Future<LearningPath> getPathDetail(String slug) async {
    final response = await _api.get(ApiEndpoints.pathDetail(slug));
    return LearningPath.fromJson(response.data);
  }

  Future<List<PathStep>> getPathSteps(String pathId) async {
    final response = await _api.get(ApiEndpoints.pathSteps(pathId));
    return (response.data as List)
        .map((j) => PathStep.fromJson(j))
        .toList();
  }
}
