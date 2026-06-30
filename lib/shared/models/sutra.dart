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

/// CBETA source URL for this sutra.
/// Returns null if cbetaId is not available.
String? sutraSourceUrl(Sutra sutra) {
  final id = sutra.cbetaId;
  if (id == null || id.isEmpty) return null;
  return 'https://cbetaonline.dila.edu.tw/zh/$id';
}
