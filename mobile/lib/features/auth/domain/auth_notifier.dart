import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/notifications/push_notification_service.dart';
import '../data/models/login_request.dart';
import '../data/models/register_request.dart';
import '../data/models/user_model.dart';
import '../data/repository/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthNotifier extends ChangeNotifier {
  AuthNotifier._();
  static final AuthNotifier instance = AuthNotifier._();

  final _repository = AuthRepository.instance;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isProfileLoading = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isProfileLoading => _isProfileLoading;

  Future<void> checkAuthStatus() async {
    final loggedIn = await _repository.isLoggedIn();
    _status = loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );
      _user = response.user;
      _status = AuthStatus.authenticated;
      notifyListeners();

      // Register this device for push now that the auth token is stored.
      // Fire-and-forget so the UI transitions immediately.
      PushNotificationService.instance.registerDevice();

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.register(
        RegisterRequest(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      );
      _user = response.user;
      _status = AuthStatus.authenticated;
      notifyListeners();

      // Register this device for push now that the auth token is stored.
      // Fire-and-forget so the UI transitions immediately.
      PushNotificationService.instance.registerDevice();

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Loads the full profile (including roles) from `/me`.
  Future<void> fetchProfile() async {
    _isProfileLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.getProfile();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Gagal memuat profil.';
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  /// Updates the profile (name and/or avatar) and refreshes the cached user.
  /// Returns true on success.
  Future<bool> updateProfile({String? name, String? avatarUrl}) async {
    _isProfileLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.updateProfile(name: name, avatarUrl: avatarUrl);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal memperbarui profil.';
      return false;
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    // Unregister the device while the auth token is still valid, so the
    // backend stops pushing to this device for the signed-out user.
    await PushNotificationService.instance.unregisterDevice();

    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
