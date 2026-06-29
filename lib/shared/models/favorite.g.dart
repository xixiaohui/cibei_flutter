// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'slug': instance.slug,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'createdAt': instance.createdAt,
    };
