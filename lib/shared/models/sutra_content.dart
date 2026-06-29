import 'package:freezed_annotation/freezed_annotation.dart';
part 'sutra_content.freezed.dart';
part 'sutra_content.g.dart';

@freezed
class SutraContent with _$SutraContent {
  const factory SutraContent({
    required String slug,
    required String title,
    required String content,
    @Default('markdown') String format,
  }) = _SutraContent;

  factory SutraContent.fromJson(Map<String, dynamic> json) =>
      _$SutraContentFromJson(json);
}
