import 'dart:convert';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/cache_manager.dart';
import '../../core/storage/hive_boxes.dart';
import '../../shared/models/sutra.dart';
import '../../shared/models/story.dart';
import '../../shared/models/learning_path.dart';
import '../../shared/models/glossary_term.dart';

class HomeRepository {
  final ApiClient _api;
  final CacheManager _cache;

  HomeRepository(this._api, this._cache);

  Future<List<Sutra>> getRecentSutras() async {
    final response = await _api.get(ApiEndpoints.sutras,
        queryParameters: {'pageSize': 5});
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => Sutra.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.homeCache, 'recent_sutras', jsonEncode(data['items']));
    return items;
  }

  Future<List<Story>> getRecentStories() async {
    final response = await _api.get(ApiEndpoints.stories,
        queryParameters: {'pageSize': 5});
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => Story.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.homeCache, 'recent_stories', jsonEncode(data['items']));
    return items;
  }

  Future<List<LearningPath>> getLearningPaths() async {
    final response = await _api.get(ApiEndpoints.paths);
    final paths =
        (response.data as List).map((j) => LearningPath.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.homeCache, 'learning_paths', jsonEncode(response.data));
    return paths;
  }

  Future<List<GlossaryTerm>> getPopularTerms() async {
    final response = await _api.get(ApiEndpoints.glossary,
        queryParameters: {'pageSize': 10});
    final data = response.data as Map<String, dynamic>;
    final items =
        (data['items'] as List).map((j) => GlossaryTerm.fromJson(j)).toList();
    await _cache.put(
        HiveBoxes.homeCache, 'popular_terms', jsonEncode(data['items']));
    return items;
  }

  Future<Map<String, dynamic>> getCachedHome() async {
    final cachedSutras =
        _cache.get<String>(HiveBoxes.homeCache, 'recent_sutras');
    final cachedStories =
        _cache.get<String>(HiveBoxes.homeCache, 'recent_stories');
    final cachedPaths =
        _cache.get<String>(HiveBoxes.homeCache, 'learning_paths');
    final cachedTerms =
        _cache.get<String>(HiveBoxes.homeCache, 'popular_terms');

    return {
      'sutras': cachedSutras != null
          ? (jsonDecode(cachedSutras) as List)
              .map((j) => Sutra.fromJson(j))
              .toList()
          : null,
      'stories': cachedStories != null
          ? (jsonDecode(cachedStories) as List)
              .map((j) => Story.fromJson(j))
              .toList()
          : null,
      'paths': cachedPaths != null
          ? (jsonDecode(cachedPaths) as List)
              .map((j) => LearningPath.fromJson(j))
              .toList()
          : null,
      'terms': cachedTerms != null
          ? (jsonDecode(cachedTerms) as List)
              .map((j) => GlossaryTerm.fromJson(j))
              .toList()
          : null,
    };
  }
}
