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
}
