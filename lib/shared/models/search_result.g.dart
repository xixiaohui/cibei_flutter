// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      type: json['type'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'slug': instance.slug,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'category': instance.category,
    };

_$SearchResponseImpl _$$SearchResponseImplFromJson(Map<String, dynamic> json) =>
    _$SearchResponseImpl(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$SearchResponseImplToJson(
        _$SearchResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
    };
