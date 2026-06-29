// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningPathImpl _$$LearningPathImplFromJson(Map<String, dynamic> json) =>
    _$LearningPathImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      levelLabel: json['levelLabel'] as String,
      icon: json['icon'] as String,
      stepCount: (json['stepCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$LearningPathImplToJson(_$LearningPathImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'level': instance.level,
      'levelLabel': instance.levelLabel,
      'icon': instance.icon,
      'stepCount': instance.stepCount,
      'createdAt': instance.createdAt,
    };
