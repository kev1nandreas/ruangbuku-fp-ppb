import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/app_notification_model.dart';

/// Wraps the backend notification feed endpoints (NotificationController).
class NotificationRepository {
  NotificationRepository._();
  static final NotificationRepository instance = NotificationRepository._();

  final _api = ApiClient.instance;
  final _storage = SecureStorage.instance;

  /// Fetches the user's feed. Optionally filtered by [category] and to
  /// [unreadOnly]. Returns the list plus the server's unread count.
  Future<NotificationFeed> fetch({
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async {
    try {
      final token = await _storage.getToken();
      final params = <String, String>{
        if (category != null) 'category': category.apiValue,
        if (unreadOnly) 'unread': '1',
      };
      final query = params.isEmpty
          ? ''
          : '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';

      final data =
          await _api.get('${ApiConstants.notifications}$query', bearerToken: token);
      final payload = data['data'] as Map<String, dynamic>?;
      if (payload == null) return const NotificationFeed.empty();

      // The feed is paginated by Laravel: data.notifications.data holds rows.
      final rows = (payload['notifications']?['data'] as List?) ?? const [];
      final items = rows
          .map((e) => AppNotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final unread = (payload['unread_count'] as num?)?.toInt() ?? 0;

      return NotificationFeed(items: items, unreadCount: unread);
    } catch (e) {
      debugPrint('NotificationRepository: fetch failed: $e');
      return const NotificationFeed.empty();
    }
  }

  /// Cheap unread badge refresh.
  Future<int> unreadCount() async {
    try {
      final token = await _storage.getToken();
      final data = await _api.get(
        '${ApiConstants.notifications}/unread-count',
        bearerToken: token,
      );
      return (data['data']?['unread_count'] as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('NotificationRepository: unreadCount failed: $e');
      return 0;
    }
  }

  Future<void> markRead(String id) async {
    final token = await _storage.getToken();
    await _api.post(
      '${ApiConstants.notifications}/$id/read',
      const {},
      bearerToken: token,
    );
  }

  Future<void> markAllRead() async {
    final token = await _storage.getToken();
    await _api.post(
      '${ApiConstants.notifications}/read-all',
      const {},
      bearerToken: token,
    );
  }

  Future<void> deleteNotification(String id) async {
    final token = await _storage.getToken();
    await _api.delete(
      '${ApiConstants.notifications}/$id',
      bearerToken: token,
    );
  }

  Future<void> clearAll() async {
    final token = await _storage.getToken();
    await _api.delete(
      '${ApiConstants.notifications}/clear-all',
      bearerToken: token,
    );
  }

  Future<void> broadcast(String title, String body) async {
    final token = await _storage.getToken();
    await _api.post(
      '${ApiConstants.notifications}/broadcast',
      {
        'title': title,
        'body': body,
      },
      bearerToken: token,
    );
  }
}

/// A page of notifications plus the server's total unread count.
class NotificationFeed {
  final List<AppNotificationModel> items;
  final int unreadCount;

  const NotificationFeed({required this.items, required this.unreadCount});
  const NotificationFeed.empty() : items = const [], unreadCount = 0;
}
