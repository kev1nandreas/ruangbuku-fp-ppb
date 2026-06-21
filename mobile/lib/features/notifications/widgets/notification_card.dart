import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';

/// Shared notification card layout: a leading avatar/icon, the title/message/
/// time block, an optional extra info line, and an optional footer (actions or
/// a status badge).
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.leading,
    required this.title,
    required this.message,
    required this.time,
    this.extraInfo,
    this.footer,
    this.elevated = true,
  });

  final Widget leading;
  final String title;
  final String message;
  final String time;
  final String? extraInfo;
  final Widget? footer;
  final bool elevated;

  /// Avatar leading from a network image (e.g. borrow requests).
  factory NotificationCard.withAvatar({
    required String avatarUrl,
    required String title,
    required String message,
    required String time,
    String? extraInfo,
    Widget? footer,
    bool elevated = true,
  }) {
    return NotificationCard(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: title,
      message: message,
      time: time,
      extraInfo: extraInfo,
      footer: footer,
      elevated: elevated,
    );
  }

  /// Tinted icon leading derived from the notification model.
  factory NotificationCard.fromModel(
    NotificationModel notif, {
    String? extraInfo,
    Widget? footer,
    bool elevated = true,
  }) {
    return NotificationCard(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: notif.iconColor.withValues(alpha: 0.1),
        child: Icon(notif.icon, color: notif.iconColor, size: 20),
      ),
      title: notif.title,
      message: notif.message,
      time: notif.time,
      extraInfo: extraInfo,
      footer: footer,
      elevated: elevated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(RuangBukuSpacing.lg),
      elevated: elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(message, style: textTheme.bodyMedium),
                    if (extraInfo != null) ...[
                      const SizedBox(height: 4),
                      Text(extraInfo!, style: textTheme.labelSmall),
                    ],
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: RuangBukuSpacing.lg),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// A pair of Decline/Accept-style buttons used as a notification footer.
class NotificationActions extends StatelessWidget {
  const NotificationActions({
    super.key,
    required this.declineLabel,
    required this.confirmLabel,
    required this.onDecline,
    required this.onConfirm,
  });

  final String declineLabel;
  final String confirmLabel;
  final VoidCallback onDecline;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 36),
              foregroundColor: RuangBukuColors.error,
              side: const BorderSide(color: RuangBukuColors.error),
            ),
            onPressed: onDecline,
            child: Text(declineLabel),
          ),
        ),
        const SizedBox(width: RuangBukuSpacing.md),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 36),
              backgroundColor: RuangBukuColors.primary,
            ),
            onPressed: onConfirm,
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
