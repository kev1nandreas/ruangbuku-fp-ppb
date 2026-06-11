import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/api_constants.dart';
import '../storage/secure_storage.dart';

/// Talks to the backend `/device-token` endpoints to register/unregister the
/// current device's FCM token against the signed-in user.
class DeviceTokenRepository {
  DeviceTokenRepository._();
  static final DeviceTokenRepository instance = DeviceTokenRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  /// Sends the token to the backend. Best-effort: failures are logged, not
  /// thrown, so a registration hiccup never blocks login.
  Future<void> register(String token) async {
    try {
      final bearer = await _storage.getToken();
      if (bearer == null) return;
      await _api.post(
        ApiConstants.deviceToken,
        {'token': token, 'platform': _platform},
        bearerToken: bearer,
      );
    } catch (e) {
      debugPrint('DeviceTokenRepository: register failed: $e');
    }
  }

  /// Removes the token server-side (called on logout). Best-effort.
  Future<void> unregister(String token) async {
    try {
      final bearer = await _storage.getToken();
      if (bearer == null) return;
      await _api.delete(
        '${ApiConstants.deviceToken}?token=${Uri.encodeQueryComponent(token)}',
        bearerToken: bearer,
      );
    } catch (e) {
      debugPrint('DeviceTokenRepository: unregister failed: $e');
    }
  }
}
