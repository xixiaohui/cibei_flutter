import 'package:freezed_annotation/freezed_annotation.dart';
part 'encyclopedia_entry.freezed.dart';
part 'encyclopedia_entry.g.dart';

@freezed
class EncyclopediaEntry with _$EncyclopediaEntry {
  const factory EncyclopediaEntry({
    required String id,
    required String slug,
    required String title,
    String? category,
    required String content,
    required String createdAt,
  }) = _EncyclopediaEntry;

  factory EncyclopediaEntry.fromJson(Map<String, dynamic> json) =>
      _$EncyclopediaEntryFromJson(json);
}
