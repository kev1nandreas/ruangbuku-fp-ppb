import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  void _showDisputeDialog(BuildContext context, BorrowModel borrowing) {
    final TextEditingController fineController = TextEditingController(text: '15000');
    final TextEditingController noteController = TextEditingController(text: 'Biaya perbaikan halaman robek');
    final state = RuangBukuState.instance;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resolve Damage Dispute'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book: ${borrowing.bookTitle}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Borrower: ${borrowing.borrowerName}'),
              Text('Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}'),
              const SizedBox(height: RuangBukuSpacing.lg),
              TextField(
                controller: fineController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Deduction Amount (Rp)',
                  hintText: 'e.g., 15000',
                ),
              ),
              const SizedBox(height: RuangBukuSpacing.md),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Decision / Note',
                  hintText: 'Biaya ganti cover / halaman robek',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: RuangBukuColors.primary),
              onPressed: () {
                final fine = double.tryParse(fineController.text.trim()) ?? 0.0;
                final note = noteController.text.trim();
                state.resolveRefundOrDispute(borrowing.id, deduction: fine, note: note);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dispute resolved. Deposit refunded after deduction.')),
                );
              },
              child: const Text('Confirm Resolution'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        // Filter notifications based on active role
        final roleNotifications = state.notifications.where((n) => n.role == state.currentRole).toList();

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
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined, size: 64, color: RuangBukuColors.primary),
                        const SizedBox(height: RuangBukuSpacing.lg),
                        Text('No Notifications', style: textTheme.titleLarge),
                        const SizedBox(height: RuangBukuSpacing.sm),
                        Text(
                          'You have no notifications in your current role.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: roleNotifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.lg),
                  itemBuilder: (context, index) {
                    final notif = roleNotifications[index];

                    // Check if it is a borrow request notification
                    final isBorrowRequest = notif.borrowId != null && notif.isPending && state.currentRole == UserRole.lender;
                    
                    // Check if it is a payment verification notification for Admin
                    final isPaymentVerification = notif.borrowId != null && notif.isPending && state.currentRole == UserRole.admin && notif.title.contains('Payment');
                    
                    // Check if it is a dispute resolution notification for Admin
                    final isDisputeResolution = notif.borrowId != null && notif.isPending && state.currentRole == UserRole.admin && notif.title.contains('Dispute');

                    if (isBorrowRequest) {
                      return _buildBorrowRequestNotification(context, state, notif);
                    } else if (isPaymentVerification) {
                      return _buildPaymentVerificationNotification(context, state, notif);
                    } else if (isDisputeResolution) {
                      return _buildDisputeResolutionNotification(context, state, notif);
                    } else {
                      return _buildSystemNotification(context, notif);
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildBorrowRequestNotification(BuildContext context, RuangBukuState state, NotificationModel notif) {
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
                backgroundImage: NetworkImage('https://picsum.photos/seed/${notif.id}/100/100'),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.message, style: textTheme.bodyMedium),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    foregroundColor: RuangBukuColors.error,
                    side: const BorderSide(color: RuangBukuColors.error),
                  ),
                  onPressed: () {
                    state.respondToBorrowRequest(notif.borrowId!, false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Borrow request declined.')),
                    );
                  },
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    backgroundColor: RuangBukuColors.primary,
                  ),
                  onPressed: () {
                    state.respondToBorrowRequest(notif.borrowId!, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Borrow request accepted (F-02)! Deep-link to WA simulated.')),
                    );
                  },
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentVerificationNotification(BuildContext context, RuangBukuState state, NotificationModel notif) {
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
                backgroundColor: notif.iconColor.withValues(alpha: 0.1),
                child: Icon(notif.icon, color: notif.iconColor, size: 20),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.message, style: textTheme.bodyMedium),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    foregroundColor: RuangBukuColors.error,
                    side: const BorderSide(color: RuangBukuColors.error),
                  ),
                  onPressed: () {
                    state.verifyDepositPayment(notif.borrowId!, false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment rejected.')),
                    );
                  },
                  child: const Text('Reject Payment'),
                ),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    backgroundColor: RuangBukuColors.primary,
                  ),
                  onPressed: () {
                    state.verifyDepositPayment(notif.borrowId!, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment verified! Deposit status changed to PAID (F-02).')),
                    );
                  },
                  child: const Text('Verify Payment'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeResolutionNotification(BuildContext context, RuangBukuState state, NotificationModel notif) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final borrowing = state.borrowings.firstWhere((b) => b.id == notif.borrowId);

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
                backgroundColor: notif.iconColor.withValues(alpha: 0.1),
                child: Icon(notif.icon, color: notif.iconColor, size: 20),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.message, style: textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}', style: textTheme.labelSmall),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
              backgroundColor: RuangBukuColors.primary,
            ),
            onPressed: () => _showDisputeDialog(context, borrowing),
            child: const Text('Resolve Dispute & Refund'),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemNotification(BuildContext context, NotificationModel notif) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: notif.iconColor.withValues(alpha: 0.1),
                child: Icon(notif.icon, color: notif.iconColor, size: 20),
              ),
              const SizedBox(width: RuangBukuSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.message, style: textTheme.bodyMedium),
                    const SizedBox(height: RuangBukuSpacing.xs),
                    Text(notif.time, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (notif.statusText != null) ...[
            const SizedBox(height: RuangBukuSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RuangBukuColors.surfaceContainerHigh,
                borderRadius: RuangBukuRadius.borderRadiusSm,
              ),
              child: Text(
                notif.statusText!,
                style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
