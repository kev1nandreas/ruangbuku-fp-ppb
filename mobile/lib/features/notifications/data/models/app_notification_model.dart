import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

/// Notification categories mirrored from the backend
/// (App\Models\AppNotification::CATEGORIES).
enum NotificationCategory {
  peminjaman,
  test,
  system;

  /// Backend string value for this category.
  String get apiValue => switch (this) {
        NotificationCategory.peminjaman => 'peminjaman_status',
        NotificationCategory.test => 'test',
        NotificationCategory.system => 'system',
      };

  String get label => switch (this) {
        NotificationCategory.peminjaman => 'Peminjaman',
        NotificationCategory.test => 'Uji Coba',
        NotificationCategory.system => 'Sistem',
      };

  static NotificationCategory fromApi(String? value) => switch (value) {
        'peminjaman_status' => NotificationCategory.peminjaman,
        'test' => NotificationCategory.test,
        _ => NotificationCategory.system,
      };
}

/// A persisted in-app notification fetched from the backend feed.
class AppNotificationModel {
  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String? peminjamanId;
  final DateTime? readAt;
  final DateTime createdAt;

  AppNotificationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    this.data = const {},
    this.peminjamanId,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      category: NotificationCategory.fromApi(json['category']?.toString()),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : const {},
      peminjamanId: json['peminjaman_id']?.toString(),
      readAt: _parseDate(json['read_at']),
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  /// Returns a copy with [readAt] set so the UI can update without a refetch.
  AppNotificationModel copyWithRead(DateTime when) => AppNotificationModel(
        id: id,
        category: category,
        title: title,
        body: body,
        data: data,
        peminjamanId: peminjamanId,
        readAt: when,
        createdAt: createdAt,
      );

  IconData get icon => switch (category) {
        NotificationCategory.peminjaman => Icons.menu_book_outlined,
        NotificationCategory.test => Icons.science_outlined,
        NotificationCategory.system => Icons.info_outline,
      };

  Color get iconColor => switch (category) {
        NotificationCategory.peminjaman => RuangBukuColors.primary,
        NotificationCategory.test => RuangBukuColors.accent,
        NotificationCategory.system => RuangBukuColors.outline,
      };

  /// Relative "time ago" label.
  String get time {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
