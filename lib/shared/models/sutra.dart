import 'package:freezed_annotation/freezed_annotation.dart';
part 'sutra.freezed.dart';
part 'sutra.g.dart';

@freezed
class Sutra with _$Sutra {
  const factory Sutra({
    required String id,
    required String slug,
    required String title,
    String? titleEn,
    String? dynasty,
    String? translator,
    String? summary,
    String? category,
    String? cbetaId,
    String? satId,
    required String createdAt,
  }) = _Sutra;

  factory Sutra.fromJson(Map<String, dynamic> json) => _$SutraFromJson(json);
}
