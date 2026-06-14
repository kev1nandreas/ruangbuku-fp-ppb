import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../models/role_model.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  Future<LoginResponse> login(LoginRequest request) async {
    final data = await _api.post(ApiConstants.login, request.toJson());
    return _persistSession(LoginResponse.fromJson(data));
  }

  /// Registers a new account. The backend returns the same shape as login
  /// (token + user), so the session is persisted and the user is signed in.
  Future<LoginResponse> register(RegisterRequest request) async {
    final data = await _api.post(ApiConstants.register, request.toJson());
    return _persistSession(LoginResponse.fromJson(data));
  }

  /// Persists the auth session locally. Must not break a successful auth call:
  /// if secure storage is unavailable, the session still proceeds in-memory.
  Future<LoginResponse> _persistSession(LoginResponse response) async {
    try {
      await _storage.saveAuthData(
        token: response.token,
        userId: response.user.id,
        userName: response.user.name,
        userEmail: response.user.email,
        userRole: response.user.primaryRoleName ?? 'borrower',
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

  /// Updates the authenticated user's profile (name and/or avatar URL).
  Future<UserModel> updateProfile({String? name, String? avatarUrl}) async {
    final token = await _storage.getToken();
    final data = await _api.put(
      ApiConstants.profile,
      {
        if (name != null) 'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
      bearerToken: token,
    );
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

  Future<UserModel?> getCachedUser() async {
    try {
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) return null;
      
      final id = await _storage.getUserId();
      final name = await _storage.getUserName();
      final email = await _storage.getUserEmail();
      final role = await _storage.getUserRole();
      
      if (id != null && name != null && email != null && role != null) {
        return UserModel(
          id: id,
          name: name,
          email: email,
          avatarUrl: null, // Avatar isn't critical for initial load
          roles: [RoleModel(id: 0, name: role)],
        );
      }
      return null;
    } catch (e) {
      debugPrint('AuthRepository: failed to read cached user: $e');
      return null;
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
