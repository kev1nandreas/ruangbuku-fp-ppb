import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/app_filter_chip.dart';
import '../../borrowing/screens/borrowing_detail_page.dart';
import '../data/models/app_notification_model.dart';
import '../domain/notification_notifier.dart';
import '../widgets/notification_card.dart';
import '../../../l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _notifier = NotificationNotifier.instance;

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final items = _notifier.items;
        final l10n = AppLocalizations.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.notificationsTitle ?? 'Notifications',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              if (_notifier.unreadCount > 0)
                TextButton(
                  onPressed: _notifier.markAllRead,
                  child: const Text('Tandai dibaca'),
                ),
              if (items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Hapus Semua',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Semua Notifikasi?'),
                        content: const Text('Semua riwayat notifikasi Anda akan dihapus secara permanen.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _notifier.clearAll();
                            },
                            child: const Text('Hapus', style: TextStyle(color: RuangBukuColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              _CategoryFilterBar(notifier: _notifier),
              const Divider(height: 1),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _notifier.load,
                  child: _buildBody(items),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(List<AppNotificationModel> items) {
    final l10n = AppLocalizations.of(context);
    
    if (_notifier.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          EmptyStateView(
            icon: Icons.notifications_off_outlined,
            title: l10n?.noNotifications ?? 'No Notifications',
            message: l10n?.noNotificationsCurrentRole ?? 'You have no notifications yet.',
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: RuangBukuSpacing.lg),
      itemBuilder: (context, index) => _buildItem(context, items[index]),
    );
  }

  Widget _buildItem(BuildContext context, AppNotificationModel notif) {
    return Dismissible(
      key: ValueKey(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: RuangBukuSpacing.lg),
        decoration: BoxDecoration(
          color: RuangBukuColors.error,
          borderRadius: RuangBukuRadius.borderRadiusMd,
        ),
        child: const Icon(Icons.delete_outline, color: RuangBukuColors.surface),
      ),
      onDismissed: (_) {
        _notifier.deleteNotification(notif);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifikasi dihapus'), duration: Duration(seconds: 2)),
        );
      },
      child: Opacity(
        opacity: notif.isRead ? 0.7 : 1.0,
        child: InkWell(
          borderRadius: RuangBukuRadius.borderRadiusMd,
          onTap: () => _onTap(notif),
          child: NotificationCard(
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: notif.iconColor.withValues(alpha: 0.1),
                  child: Icon(notif.icon, color: notif.iconColor, size: 20),
                ),
                if (!notif.isRead)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: RuangBukuColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: notif.title,
            message: notif.body,
            time: notif.time,
            elevated: !notif.isRead,
          ),
        ),
      ),
    );
  }

  void _onTap(AppNotificationModel notif) {
    _notifier.markRead(notif);

    // Deep-link peminjaman notifications to the borrow detail.
    if (notif.category == NotificationCategory.peminjaman &&
        notif.peminjamanId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BorrowingDetailPage(borrowingId: notif.peminjamanId!),
        ),
      );
    }
  }
}

/// Horizontal row of category filter chips (All / Peminjaman / Test / System).
class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({required this.notifier});

  final NotificationNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final active = notifier.categoryFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.marginMobile,
        vertical: RuangBukuSpacing.md,
      ),
      child: Row(
        children: [
          AppFilterChip(
            label: 'Semua',
            isSelected: active == null,
            onTap: () => notifier.setCategory(null),
          ),
          const SizedBox(width: RuangBukuSpacing.sm),
          ...NotificationCategory.values.map((c) => Padding(
                padding: const EdgeInsets.only(right: RuangBukuSpacing.sm),
                child: AppFilterChip(
                  label: c.label,
                  isSelected: active == c,
                  onTap: () => notifier.setCategory(c),
                ),
              )),
        ],
      ),
    );
  }
}
