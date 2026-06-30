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
    final response = await _api.get(ApiEndpoints.paths);
    // API returns a plain array, not a paginated wrapper.
    final list = (response.data as List)
        .map((j) => LearningPath.fromJson(j as Map<String, dynamic>))
        .toList();
    await _cache.put(HiveBoxes.pathCache, 'list', jsonEncode(response.data));
    return (
      items: list,
      total: list.length,
      page: 1,
      totalPages: 1,
    );
  }

  Future<({LearningPath path, List<PathStep> steps})> getPathDetail(
      String slug) async {
    final response = await _api.get(ApiEndpoints.pathDetail(slug));
    final data = response.data as Map<String, dynamic>;
    // API wraps path + steps: { path: {...}, steps: [...] }
    final path =
        LearningPath.fromJson(data['path'] as Map<String, dynamic>);
    final rawSteps = (data['steps'] as List)
        .map((j) => PathStep.fromJson(j as Map<String, dynamic>))
        .toList();
    // Deduplicate by stepNumber — keeps the first occurrence of each step.
    final seen = <int>{};
    final steps = rawSteps.where((s) => seen.add(s.stepNumber)).toList();
    return (path: path, steps: steps);
  }
}
