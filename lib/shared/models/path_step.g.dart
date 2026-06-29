// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PathStepImpl _$$PathStepImplFromJson(Map<String, dynamic> json) =>
    _$PathStepImpl(
      id: json['id'] as String,
      pathId: json['pathId'] as String,
      stepNumber: (json['stepNumber'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      guidance: json['guidance'] as String?,
      relatedSutraSlugs: (json['relatedSutraSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      relatedTermSlugs: (json['relatedTermSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$PathStepImplToJson(_$PathStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pathId': instance.pathId,
      'stepNumber': instance.stepNumber,
      'title': instance.title,
      'description': instance.description,
      'guidance': instance.guidance,
      'relatedSutraSlugs': instance.relatedSutraSlugs,
      'relatedTermSlugs': instance.relatedTermSlugs,
      'createdAt': instance.createdAt,
    };
