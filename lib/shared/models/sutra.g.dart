// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sutra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SutraImpl _$$SutraImplFromJson(Map<String, dynamic> json) => _$SutraImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      dynasty: json['dynasty'] as String?,
      translator: json['translator'] as String?,
      summary: json['summary'] as String?,
      category: json['category'] as String?,
      cbetaId: json['cbetaId'] as String?,
      satId: json['satId'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$SutraImplToJson(_$SutraImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'titleEn': instance.titleEn,
      'dynasty': instance.dynasty,
      'translator': instance.translator,
      'summary': instance.summary,
      'category': instance.category,
      'cbetaId': instance.cbetaId,
      'satId': instance.satId,
      'createdAt': instance.createdAt,
    };
