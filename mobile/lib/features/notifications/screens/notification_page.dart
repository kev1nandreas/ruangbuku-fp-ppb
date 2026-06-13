import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../widgets/notification_card.dart';
import '../widgets/dispute_resolution_dialog.dart';
import '../../../l10n/app_localizations.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final l10n = AppLocalizations.of(context);

        // Filter notifications based on active role
        final roleNotifications =
            state.notifications.where((n) => n.role == state.currentRole).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.notificationsTitle ?? 'Notifications',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: roleNotifications.isEmpty
              ? EmptyStateView(
                  icon: Icons.notifications_off_outlined,
                  title: l10n?.noNotifications ?? 'No Notifications',
                  message: l10n?.noNotificationsCurrentRole ?? 'You have no notifications in your current role.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: roleNotifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: RuangBukuSpacing.lg),
                  itemBuilder: (context, index) =>
                      _buildNotification(context, state, roleNotifications[index]),
                ),
        );
      },
    );
  }

  Widget _buildNotification(
      BuildContext context, RuangBukuState state, NotificationModel notif) {
    final l10n = AppLocalizations.of(context);
    final isActionable = notif.borrowId != null && notif.isPending;
    final role = state.currentRole;

    if (isActionable && role == UserRole.lender) {
      return NotificationCard.withAvatar(
        avatarUrl: 'https://picsum.photos/seed/${notif.id}/100/100',
        title: notif.title,
        message: notif.message,
        time: notif.time,
        footer: NotificationActions(
          declineLabel: l10n?.declineLabel ?? 'Decline',
          confirmLabel: l10n?.acceptLabel ?? 'Accept',
          onDecline: () {
            state.respondToBorrowRequest(notif.borrowId!, false);
            _snack(context, l10n?.borrowRequestDeclined ?? 'Borrow request declined.');
          },
          onConfirm: () {
            state.respondToBorrowRequest(notif.borrowId!, true);
            _snack(context,
                l10n?.borrowRequestAccepted ?? 'Borrow request accepted (F-02)! Deep-link to WA simulated.');
          },
        ),
      );
    }

    if (isActionable &&
        role == UserRole.admin &&
        notif.title.contains('Payment')) {
      return NotificationCard.fromModel(
        notif,
        footer: NotificationActions(
          declineLabel: l10n?.rejectPayment ?? 'Reject Payment',
          confirmLabel: l10n?.verifyPayment ?? 'Verify Payment',
          onDecline: () {
            state.verifyDepositPayment(notif.borrowId!, false);
            _snack(context, l10n?.paymentRejected ?? 'Payment rejected.');
          },
          onConfirm: () {
            state.verifyDepositPayment(notif.borrowId!, true);
            _snack(context,
                l10n?.paymentVerified ?? 'Payment verified! Deposit status changed to PAID (F-02).');
          },
        ),
      );
    }

    if (isActionable &&
        role == UserRole.admin &&
        notif.title.contains('Dispute')) {
      final borrowing =
          state.borrowings.firstWhere((b) => b.id == notif.borrowId);
      return NotificationCard.fromModel(
        notif,
        extraInfo:
            l10n?.reportedDamageLabel(borrowing.damageReport?.description ?? "N/A") ?? 'Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}',
        footer: FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
            backgroundColor: RuangBukuColors.primary,
          ),
          onPressed: () => showDisputeResolutionDialog(context, borrowing),
          child: Text(l10n?.resolveDisputeRefund ?? 'Resolve Dispute & Refund'),
        ),
      );
    }

    // System / informational notification
    return NotificationCard.fromModel(
      notif,
      elevated: false,
      footer: notif.statusText != null
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RuangBukuColors.surfaceContainerHigh,
                borderRadius: RuangBukuRadius.borderRadiusSm,
              ),
              child: Text(
                notif.statusText!,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            )
          : null,
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
