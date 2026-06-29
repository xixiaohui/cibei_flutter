import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    @Default(false) bool emailVerified,
    String? name,
    String? image,
    required String createdAt,
    String? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    required String userId,
    required String token,
    required String expiresAt,
    String? ipAddress,
    String? userAgent,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    Session? session,
    User? user,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}
