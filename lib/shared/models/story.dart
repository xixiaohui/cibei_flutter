import 'package:freezed_annotation/freezed_annotation.dart';
part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String slug,
    required String title,
    String? titleEn,
    required String category,
    String? sourceSutra,
    required String summary,
    required String content,
    String? moral,
    String? imageUrl,
    required String createdAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
