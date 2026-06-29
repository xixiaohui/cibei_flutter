import 'package:freezed_annotation/freezed_annotation.dart';
part 'learning_path.freezed.dart';
part 'learning_path.g.dart';

@freezed
class LearningPath with _$LearningPath {
  const factory LearningPath({
    required String id,
    required String slug,
    required String title,
    required String description,
    required String level,
    required String levelLabel,
    required String icon,
    required int stepCount,
    required String createdAt,
  }) = _LearningPath;

  factory LearningPath.fromJson(Map<String, dynamic> json) =>
      _$LearningPathFromJson(json);
}
