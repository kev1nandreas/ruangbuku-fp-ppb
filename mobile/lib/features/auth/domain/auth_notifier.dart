import 'package:flutter/foundation.dart';
import '../../../core/api/api_client.dart';
import '../../../core/state.dart';
import '../../../core/notifications/push_notification_service.dart';
import '../data/models/login_request.dart';
import '../data/models/register_request.dart';
import '../data/models/user_model.dart';
import '../data/repository/auth_repository.dart';
import '../../../db/local_bookDB.dart';
import '../../notifications/domain/notification_notifier.dart';

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
    final cachedUser = await _repository.getCachedUser();
    if (cachedUser != null) {
      _user = cachedUser;
      
      // Wait for fetchProfile to ensure we have the absolute latest role from backend
      // before transitioning away from the splash screen.
      await fetchProfile();

      // Set the role into state BEFORE flipping to authenticated so the first
      // post-splash rebuild routes to the correct scaffold.
      _syncRoleToState(_user?.primaryRoleName); // Fallback to cache if fetch failed
      await _syncUserToLocalDB();
      _status = AuthStatus.authenticated;
      RuangBukuState.instance.initializeData();
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void _syncRoleToState(String? roleName) {
    if (roleName == 'admin') {
      RuangBukuState.instance.changeRole(UserRole.admin);
    } else {
      RuangBukuState.instance.changeRole(UserRole.borrower);
    }
  }

  Future<void> _syncUserToLocalDB() async {
    if (_user == null) return;
    final db = LocalBookDB.instance;
    await db.upsertUser({
      'backend_id': _user!.id,
      'name': _user!.name,
      'email': _user!.email,
      'avatarUrl': _user!.avatarUrl,
    });
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
      // Sync the role into state BEFORE flipping to authenticated, so the first
      // rebuild already routes to the correct scaffold (no borrower-default flash).
      _syncRoleToState(response.user.primaryRoleName);
      await _syncUserToLocalDB();
      _status = AuthStatus.authenticated;
      RuangBukuState.instance.initializeData();
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
      // Sync the role into state BEFORE flipping to authenticated, so the first
      // rebuild already routes to the correct scaffold (no borrower-default flash).
      _syncRoleToState(response.user.primaryRoleName);
      await _syncUserToLocalDB();
      _status = AuthStatus.authenticated;
      RuangBukuState.instance.initializeData();
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
      if (_user != null) {
        _syncRoleToState(_user!.primaryRoleName);
        await _syncUserToLocalDB();
      }
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

    // Wipe per-user session state held in the other singletons so the next
    // account to sign in starts clean (no stale role, books, borrowings, or
    // notifications leaking from the previous user).
    RuangBukuState.instance.reset();
    NotificationNotifier.instance.reset();

    notifyListeners();
  }
}
