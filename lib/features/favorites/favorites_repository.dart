import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../shared/models/favorite.dart';

class FavoritesRepository {
  final ApiClient _api;
  FavoritesRepository(this._api);

  Future<List<Favorite>> getFavorites() async {
    final response = await _api.get(ApiEndpoints.favorites);
    return (response.data as List).map((j) => Favorite.fromJson(j)).toList();
  }

  /// Returns true if now favorited, false if unfavorited
  Future<bool> toggleFavorite(
      {required String type,
      required String slug,
      required String title,
      String? subtitle}) async {
    final response = await _api.post(ApiEndpoints.favorites, data: {
      'type': type,
      'slug': slug,
      'title': title,
      'subtitle': subtitle,
    });
    return response.data['favorited'] as bool;
  }

  Future<void> removeFavorite(String id) async {
    await _api.delete(ApiEndpoints.favoriteDelete(id));
  }

  Future<bool> checkFavorite(String type, String slug) async {
    final response = await _api.get(ApiEndpoints.favoriteCheck,
        queryParameters: {'type': type, 'slug': slug});
    return response.data['favorited'] as bool;
  }
}
