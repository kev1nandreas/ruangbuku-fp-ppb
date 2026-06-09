import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../widgets/notification_card.dart';
import '../widgets/dispute_resolution_dialog.dart';

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

        // Filter notifications based on active role
        final roleNotifications =
            state.notifications.where((n) => n.role == state.currentRole).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: roleNotifications.isEmpty
              ? const EmptyStateView(
                  icon: Icons.notifications_off_outlined,
                  title: 'No Notifications',
                  message: 'You have no notifications in your current role.',
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
    final isActionable = notif.borrowId != null && notif.isPending;
    final role = state.currentRole;

    if (isActionable && role == UserRole.lender) {
      return NotificationCard.withAvatar(
        avatarUrl: 'https://picsum.photos/seed/${notif.id}/100/100',
        title: notif.title,
        message: notif.message,
        time: notif.time,
        footer: NotificationActions(
          declineLabel: 'Decline',
          confirmLabel: 'Accept',
          onDecline: () {
            state.respondToBorrowRequest(notif.borrowId!, false);
            _snack(context, 'Borrow request declined.');
          },
          onConfirm: () {
            state.respondToBorrowRequest(notif.borrowId!, true);
            _snack(context,
                'Borrow request accepted (F-02)! Deep-link to WA simulated.');
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
          declineLabel: 'Reject Payment',
          confirmLabel: 'Verify Payment',
          onDecline: () {
            state.verifyDepositPayment(notif.borrowId!, false);
            _snack(context, 'Payment rejected.');
          },
          onConfirm: () {
            state.verifyDepositPayment(notif.borrowId!, true);
            _snack(context,
                'Payment verified! Deposit status changed to PAID (F-02).');
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
            'Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}',
        footer: FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 36),
            backgroundColor: RuangBukuColors.primary,
          ),
          onPressed: () => showDisputeResolutionDialog(context, borrowing),
          child: const Text('Resolve Dispute & Refund'),
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
