import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../shared/models/user.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _api.post(ApiEndpoints.signIn,
        data: {'email': email, 'password': password});
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> signUp(
      String email, String password, String name) async {
    final response = await _api.post(ApiEndpoints.signUp,
        data: {'email': email, 'password': password, 'name': name});
    return AuthResponse.fromJson(response.data);
  }

  Future<SessionResponse?> getSession() async {
    try {
      final response = await _api.get(ApiEndpoints.getSession);
      return SessionResponse.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _api.post(ApiEndpoints.signOut);
    } catch (_) {
      // Server may return redirect or empty body — ignore, just clear cookies
    }
    _api.clearCookies();
  }
}
