// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sutra_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SutraContentImpl _$$SutraContentImplFromJson(Map<String, dynamic> json) =>
    _$SutraContentImpl(
      slug: json['slug'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      format: json['format'] as String? ?? 'markdown',
    );

Map<String, dynamic> _$$SutraContentImplToJson(_$SutraContentImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'content': instance.content,
      'format': instance.format,
    };
