import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  Future<LoginResponse> login(LoginRequest request) async {
    final data = await _api.post(ApiConstants.login, request.toJson());
    final response = LoginResponse.fromJson(data);

    // Persisting the session must not break a successful login. If secure
    // storage is unavailable, the session still proceeds in-memory.
    try {
      await _storage.saveAuthData(
        token: response.token,
        userId: response.user.id,
        userName: response.user.name,
        userEmail: response.user.email,
      );
    } catch (e) {
      debugPrint('AuthRepository: failed to persist session: $e');
    }

    return response;
  }

  /// Fetches the authenticated user's profile from `/me` using the stored token.
  Future<UserModel> getProfile() async {
    final token = await _storage.getToken();
    final data = await _api.get(ApiConstants.me, bearerToken: token);
    return UserModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final token = await _storage.getToken();

    // Best-effort server-side logout; clear local session regardless.
    try {
      await _api.post(ApiConstants.logout, const {}, bearerToken: token);
    } catch (e) {
      debugPrint('AuthRepository: server logout failed: $e');
    }

    try {
      await _storage.clearAll();
    } catch (e) {
      debugPrint('AuthRepository: failed to clear session: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('AuthRepository: failed to read session: $e');
      return false;
    }
  }
}
