// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedResponseImpl _$$PaginatedResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedResponseImpl(
      items: json['items'] as List<dynamic>? ?? const [],
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginatedResponseImplToJson(
        _$PaginatedResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
    };
