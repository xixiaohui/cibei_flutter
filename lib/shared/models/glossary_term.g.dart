// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glossary_term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlossaryTermImpl _$$GlossaryTermImplFromJson(Map<String, dynamic> json) =>
    _$GlossaryTermImpl(
      id: json['id'] as String,
      slug: json['slug'] as String,
      term: json['term'] as String,
      termEn: json['termEn'] as String?,
      termSanskrit: json['termSanskrit'] as String?,
      definition: json['definition'] as String,
      relatedTerms: (json['relatedTerms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$GlossaryTermImplToJson(_$GlossaryTermImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'term': instance.term,
      'termEn': instance.termEn,
      'termSanskrit': instance.termSanskrit,
      'definition': instance.definition,
      'relatedTerms': instance.relatedTerms,
      'createdAt': instance.createdAt,
    };
