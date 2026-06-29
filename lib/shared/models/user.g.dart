// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      name: json['name'] as String?,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'name': instance.name,
      'image': instance.image,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      expiresAt: json['expiresAt'] as String,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'token': instance.token,
      'expiresAt': instance.expiresAt,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
    };

_$SessionResponseImpl _$$SessionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionResponseImpl(
      session: json['session'] == null
          ? null
          : Session.fromJson(json['session'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SessionResponseImplToJson(
        _$SessionResponseImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'user': instance.user,
    };
