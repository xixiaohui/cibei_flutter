import 'package:freezed_annotation/freezed_annotation.dart';
part 'path_step.freezed.dart';
part 'path_step.g.dart';

@freezed
class PathStep with _$PathStep {
  const factory PathStep({
    required String id,
    required String pathId,
    required int stepNumber,
    required String title,
    String? description,
    String? guidance,
    @Default([]) List<String> relatedSutraSlugs,
    @Default([]) List<String> relatedTermSlugs,
    required String createdAt,
  }) = _PathStep;

  factory PathStep.fromJson(Map<String, dynamic> json) =>
      _$PathStepFromJson(json);
}
