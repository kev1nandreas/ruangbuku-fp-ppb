import 'package:flutter/foundation.dart';
import '../data/models/app_notification_model.dart';
import '../data/repository/notification_repository.dart';

/// Holds the notification feed state: the loaded list, the unread count, the
/// active category filter, and loading flags. Drives the notification page via
/// [ListenableBuilder].
class NotificationNotifier extends ChangeNotifier {
  NotificationNotifier._();
  static final NotificationNotifier instance = NotificationNotifier._();

  final _repository = NotificationRepository.instance;

  List<AppNotificationModel> _items = [];
  int _unreadCount = 0;
  NotificationCategory? _categoryFilter;
  bool _loading = false;

  List<AppNotificationModel> get items => _items;
  int get unreadCount => _unreadCount;
  NotificationCategory? get categoryFilter => _categoryFilter;
  bool get isLoading => _loading;

  /// Loads (or reloads) the feed for the active [_categoryFilter].
  Future<void> load() async {
    _loading = true;
    notifyListeners();

    final feed = await _repository.fetch(category: _categoryFilter);
    _items = feed.items;
    _unreadCount = feed.unreadCount;
    _loading = false;
    notifyListeners();
  }

  /// Changes the category filter and reloads. Pass null for "all".
  Future<void> setCategory(NotificationCategory? category) async {
    if (_categoryFilter == category) return;
    _categoryFilter = category;
    await load();
  }

  /// Marks one notification read locally and on the server.
  Future<void> markRead(AppNotificationModel notif) async {
    if (notif.isRead) return;

    final index = _items.indexWhere((n) => n.id == notif.id);
    if (index != -1) {
      _items[index] = _items[index].copyWithRead(DateTime.now());
      _unreadCount = (_unreadCount - 1).clamp(0, 1 << 30);
      notifyListeners();
    }

    try {
      await _repository.markRead(notif.id);
    } catch (e) {
      debugPrint('NotificationNotifier: markRead failed: $e');
    }
  }

  /// Marks every notification read locally and on the server.
  Future<void> markAllRead() async {
    final now = DateTime.now();
    _items = _items
        .map((n) => n.isRead ? n : n.copyWithRead(now))
        .toList();
    _unreadCount = 0;
    notifyListeners();

    try {
      await _repository.markAllRead();
    } catch (e) {
      debugPrint('NotificationNotifier: markAllRead failed: $e');
    }
  }

  /// Refreshes only the unread badge (e.g. on tab focus).
  Future<void> refreshUnreadCount() async {
    _unreadCount = await _repository.unreadCount();
    notifyListeners();
  }
}
