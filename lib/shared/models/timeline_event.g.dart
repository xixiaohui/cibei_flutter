// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineEventImpl _$$TimelineEventImplFromJson(Map<String, dynamic> json) =>
    _$TimelineEventImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      year: (json['year'] as num).toInt(),
      yearDisplay: json['yearDisplay'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      location: json['location'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$TimelineEventImplToJson(_$TimelineEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'year': instance.year,
      'yearDisplay': instance.yearDisplay,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'location': instance.location,
      'createdAt': instance.createdAt,
    };
