// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encyclopedia_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EncyclopediaEntryImpl _$$EncyclopediaEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$EncyclopediaEntryImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      category: json['category'] as String?,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$EncyclopediaEntryImplToJson(
        _$EncyclopediaEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'category': instance.category,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
