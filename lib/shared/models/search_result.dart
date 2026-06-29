import 'package:freezed_annotation/freezed_annotation.dart';
part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String type,
    required String slug,
    required String title,
    required String excerpt,
    String? category,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

@freezed
class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    @Default([]) List<SearchResult> results,
    required int total,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
