// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryImpl _$$StoryImplFromJson(Map<String, dynamic> json) => _$StoryImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      category: json['category'] as String,
      sourceSutra: json['sourceSutra'] as String?,
      summary: json['summary'] as String,
      content: json['content'] as String,
      moral: json['moral'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$StoryImplToJson(_$StoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'titleEn': instance.titleEn,
      'category': instance.category,
      'sourceSutra': instance.sourceSutra,
      'summary': instance.summary,
      'content': instance.content,
      'moral': instance.moral,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
    };
