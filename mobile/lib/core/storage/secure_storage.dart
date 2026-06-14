import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyAuthToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  // Preferences Keys
  static const _keyThemeMode = 'pref_theme_mode';
  static const _keyLanguage = 'pref_language';
  static const _keyNotifBorrow = 'pref_notif_borrow';
  static const _keyNotifSla = 'pref_notif_sla';
  static const _keyNotifHandover = 'pref_notif_handover';
  static const _keyPublicDefault = 'pref_public_default';
  static const _keyHideWa = 'pref_hide_wa';

  Future<void> saveAuthData({
    required String token,
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAuthToken, value: token),
      _storage.write(key: _keyUserId, value: userId),
      _storage.write(key: _keyUserName, value: userName),
      _storage.write(key: _keyUserEmail, value: userEmail),
    ]);
  }

  Future<String?> getToken() => _storage.read(key: _keyAuthToken);
  Future<String?> getUserId() => _storage.read(key: _keyUserId);
  Future<String?> getUserName() => _storage.read(key: _keyUserName);
  Future<String?> getUserEmail() => _storage.read(key: _keyUserEmail);

  Future<void> clearAll() => _storage.deleteAll();

  // Settings getters
  Future<String?> getThemeMode() => _storage.read(key: _keyThemeMode);
  Future<String?> getLanguage() => _storage.read(key: _keyLanguage);
  Future<String?> getNotifBorrow() => _storage.read(key: _keyNotifBorrow);
  Future<String?> getNotifSla() => _storage.read(key: _keyNotifSla);
  Future<String?> getNotifHandover() => _storage.read(key: _keyNotifHandover);
  Future<String?> getPublicDefault() => _storage.read(key: _keyPublicDefault);
  Future<String?> getHideWa() => _storage.read(key: _keyHideWa);

  // Settings setters
  Future<void> setThemeMode(String value) => _storage.write(key: _keyThemeMode, value: value);
  Future<void> setLanguage(String value) => _storage.write(key: _keyLanguage, value: value);
  Future<void> setNotifBorrow(String value) => _storage.write(key: _keyNotifBorrow, value: value);
  Future<void> setNotifSla(String value) => _storage.write(key: _keyNotifSla, value: value);
  Future<void> setNotifHandover(String value) => _storage.write(key: _keyNotifHandover, value: value);
  Future<void> setPublicDefault(String value) => _storage.write(key: _keyPublicDefault, value: value);
  Future<void> setHideWa(String value) => _storage.write(key: _keyHideWa, value: value);
}
