import 'package:freezed_annotation/freezed_annotation.dart';
part 'paginated_response.freezed.dart';
part 'paginated_response.g.dart';

@freezed
class PaginatedResponse with _$PaginatedResponse {
  const factory PaginatedResponse({
    @Default([]) List<dynamic> items,
    required int total,
    required int page,
    required int pageSize,
    required int totalPages,
  }) = _PaginatedResponse;

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResponseFromJson(json);
}
