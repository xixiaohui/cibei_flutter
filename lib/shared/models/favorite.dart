import 'package:freezed_annotation/freezed_annotation.dart';
part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    required String userId,
    required String type, // sutra | glossary | story | encyclopedia
    required String slug,
    required String title,
    String? subtitle,
    required String createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}
