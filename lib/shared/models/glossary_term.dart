import 'package:freezed_annotation/freezed_annotation.dart';
part 'glossary_term.freezed.dart';
part 'glossary_term.g.dart';

@freezed
class GlossaryTerm with _$GlossaryTerm {
  const factory GlossaryTerm({
    required String id,
    required String slug,
    required String term,
    String? termEn,
    String? termSanskrit,
    required String definition,
    @Default([]) List<String> relatedTerms,
    required String createdAt,
  }) = _GlossaryTerm;

  factory GlossaryTerm.fromJson(Map<String, dynamic> json) =>
      _$GlossaryTermFromJson(json);
}
