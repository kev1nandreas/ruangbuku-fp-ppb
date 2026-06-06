import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        children: [
          _buildNotificationGroup(context, title: 'Today'),
          const SizedBox(height: RuangBukuSpacing.md),
          _buildBorrowRequestNotification(
            context,
            name: 'Sarah M.',
            bookTitle: 'The Midnight Library',
            avatarUrl: 'https://picsum.photos/seed/notif1/100/100',
            time: '2 hours ago',
            isPending: true,
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          _buildSystemNotification(
            context,
            title: 'Admin Curation',
            message: 'Your book "Sapiens" has been approved and is now visible to the community.',
            time: '5 hours ago',
            icon: Icons.check_circle,
            iconColor: semanticColors.success,
          ),

          const SizedBox(height: RuangBukuSpacing.xxl),

          _buildNotificationGroup(context, title: 'Yesterday'),
          const SizedBox(height: RuangBukuSpacing.md),
          _buildBorrowRequestNotification(
            context,
            name: 'David T.',
            bookTitle: 'Dune',
            avatarUrl: 'https://picsum.photos/seed/notif2/100/100',
            time: '1 day ago',
            isPending: false,
            statusText: 'Accepted',
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          _buildSystemNotification(
            context,
            title: 'Return Reminder',
            message: 'Your borrowed book "Atomic Habits" is due tomorrow. Please coordinate with James C. for return.',
            time: '1 day ago',
            icon: Icons.access_time_filled,
            iconColor: RuangBukuColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationGroup(BuildContext context, {required String title}) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: RuangBukuColors.textSecondary,
      ),
    );
  }

  Widget _buildBorrowRequestNotification(
    BuildContext context, {
    required String name,
    required String bookTitle,
    required String avatarUrl,
    required String time,
    required bool isPending,
    String? statusText,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        boxShadow: RuangBukuElevation.level1,
        border: Border.all(
          color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: [
                          TextSpan(text: name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: ' requested to borrow '),
                          TextSpan(text: bookTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: RuangBukuSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ] else if (statusText != null) ...[
            const SizedBox(height: RuangBukuSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RuangBukuColors.surfaceContainerHigh,
                borderRadius: RuangBukuRadius.borderRadiusSm,
              ),
              child: Text(
                statusText,
                style: textTheme.labelMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemNotification(
    BuildContext context, {
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        border: Border.all(
          color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withValues(alpha: 0.1),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: RuangBukuSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: RuangBukuSpacing.xs),
                Text(message, style: textTheme.bodyMedium),
                const SizedBox(height: RuangBukuSpacing.sm),
                Text(time, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

