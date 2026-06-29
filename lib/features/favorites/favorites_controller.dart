import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../shared/models/favorite.dart';
import 'favorites_repository.dart';

final favoritesRepositoryProvider =
    Provider((ref) => FavoritesRepository(ApiClient()));

final favoritesProvider = AsyncNotifierProvider<FavoritesController, List<Favorite>>(
    () => FavoritesController());

class FavoritesController extends AsyncNotifier<List<Favorite>> {
  @override
  Future<List<Favorite>> build() async {
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  Future<void> toggle(String type, String slug, String title,
      {String? subtitle}) async {
    await ref.read(favoritesRepositoryProvider).toggleFavorite(
        type: type, slug: slug, title: title, subtitle: subtitle);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    await ref.read(favoritesRepositoryProvider).removeFavorite(id);
    ref.invalidateSelf();
  }
}

// Check individual item favorite status
final favoriteStatusProvider =
    FutureProvider.family<bool, ({String type, String slug})>((ref, params) {
  return ref
      .read(favoritesRepositoryProvider)
      .checkFavorite(params.type, params.slug);
});
