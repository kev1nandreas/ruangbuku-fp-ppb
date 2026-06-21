import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import 'device_token_repository.dart';

/// Channel id must match `default_notification_channel_id` in
/// AndroidManifest.xml so background/terminated messages and foreground
/// notifications land in the same channel.
const _channelId = 'ruangbuku_status';
const _channelName = 'Status Peminjaman';
const _channelDescription = 'Notifikasi perubahan status peminjaman buku.';

/// Handles FCM messages while the app is in the background or terminated.
///
/// Must be a top-level (or static) function annotated with
/// `@pragma('vm:entry-point')` because it runs in a separate isolate. On
/// Android the system tray notification is drawn by FCM automatically, so we
/// only ensure Firebase is initialized here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // No UI work needed: a `notification` payload is rendered by the OS.
  debugPrint('Background FCM message: ${message.messageId}');
}

/// Owns Firebase Messaging setup: permissions, the device token lifecycle,
/// and foreground notification display.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  // Resolved lazily: touching FirebaseMessaging.instance before
  // Firebase.initializeApp() throws `[core/no-app]`, and this field would
  // otherwise evaluate when the singleton is first constructed.
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _deviceTokenRepo = DeviceTokenRepository.instance;

  bool _initialized = false;
  String? _currentToken;

  /// One-time Firebase + listener setup. Safe to call again (no-op after the
  /// first success). Call once at app startup, before runApp.
  Future<void> initialize() async {
    if (_initialized) return;

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _setupLocalNotifications();

    // Foreground messages don't show a tray notification by default, so we
    // render one ourselves via flutter_local_notifications.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // Keep the backend in sync if FCM rotates the token mid-session.
    _messaging.onTokenRefresh.listen((token) {
      _currentToken = token;
      _deviceTokenRepo.register(token);
    });

    _initialized = true;
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(initSettings);

    // Pre-create the Android channel so foreground notifications have it.
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['peminjaman_id'] as String?,
    );
  }

  /// Requests notification permission (Android 13+ / iOS), fetches the FCM
  /// token, and registers it with the backend. Call right after a successful
  /// login, once the auth token is stored.
  Future<void> registerDevice() async {
    try {
      final settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('PushNotificationService: notifications denied by user');
        return;
      }

      final token = await _messaging.getToken();
      if (token == null) return;

      _currentToken = token;
      await _deviceTokenRepo.register(token);
    } catch (e) {
      debugPrint('PushNotificationService: registerDevice failed: $e');
    }
  }

  /// Unregisters the token server-side and deletes it locally so a shared
  /// device stops receiving notifications for the signed-out user. Call on
  /// logout, before the auth token is cleared.
  Future<void> unregisterDevice() async {
    try {
      final token = _currentToken ?? await _messaging.getToken();
      if (token != null) {
        await _deviceTokenRepo.unregister(token);
      }
      await _messaging.deleteToken();
      _currentToken = null;
    } catch (e) {
      debugPrint('PushNotificationService: unregisterDevice failed: $e');
    }
  }
}
