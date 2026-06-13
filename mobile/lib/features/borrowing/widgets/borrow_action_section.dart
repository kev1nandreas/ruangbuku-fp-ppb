import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../screens/request_borrow_page.dart';
import '../../auth/domain/auth_notifier.dart';
import 'deposit_proof.dart';

/// Contextual call-to-action shown in the borrower book detail bottom sheet.
/// Renders the right control for the current borrowing lifecycle state.
class BorrowActionSection extends StatelessWidget {
  const BorrowActionSection({
    super.key,
    required this.book,
    required this.borrowing,
  });

  final BookModel book;
  final BorrowModel? borrowing;

  void _goToRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestBorrowPage(bookId: book.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = RuangBukuState.instance;

    final currentUserId = AuthNotifier.instance.user?.id ?? '';

    // If own book
    if (book.ownerId == currentUserId) {
      return const OutlinedButton(
        onPressed: null,
        child: Text('This is your own book'),
      );
    }

    if (borrowing == null) {
      // This book already has an active borrow by someone (incl. current user
      // via a different status not caught above) — block requesting it.
      final isAlreadyBorrowed = state.borrowings.any((b) =>
          b.bookId == book.id &&
          b.status != BorrowStatus.completed &&
          b.status != BorrowStatus.cancelled);

      if (isAlreadyBorrowed) {
        return const OutlinedButton(
          onPressed: null,
          child: Text('Book Currently on Loan'),
        );
      }

      // Backend rule: a user may hold only one active borrow at a time. Reflect
      // that here so the user can't spam requests only to get a 422.
      final hasActiveElsewhere = state.borrowings.any((b) =>
          b.borrowerId == currentUserId &&
          b.status != BorrowStatus.completed &&
          b.status != BorrowStatus.cancelled);

      if (hasActiveElsewhere) {
        return _statusColumn(
          message: 'Finish your active borrowing before requesting another.',
          messageColor: RuangBukuColors.textSecondary,
          action: const OutlinedButton(
            onPressed: null,
            child: Text('Borrow Book'),
          ),
        );
      }

      return FilledButton(
        onPressed: () => _goToRequest(context),
        child: const Text('Borrow Book'),
      );
    }

    switch (borrowing!.status) {
      case BorrowStatus.requested:
        return _statusColumn(
          message: 'Waiting for Lender approval...',
          messageColor: RuangBukuColors.primary,
          messageBold: true,
          action: const OutlinedButton(
            onPressed: null,
            child: Text('Requested'),
          ),
        );
      case BorrowStatus.waitingDeposit:
        return _statusColumn(
          message: 'Lender approved! Please pay the deposit.',
          action: FilledButton(
            onPressed: () => pickAndUploadDepositProof(context, borrowing!.id),
            child: const Text('Upload Deposit Proof (Rp. 50,000)'),
          ),
        );
      case BorrowStatus.depositUploaded:
        return _statusColumn(
          message: 'Deposit proof submitted.',
          action: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (borrowing!.paymentProofUrl != null &&
                  borrowing!.paymentProofUrl!.isNotEmpty)
                OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  onPressed: () => showDepositProofViewer(
                      context, borrowing!.paymentProofUrl!),
                  label: const Text('View Deposit Proof'),
                ),
              const SizedBox(height: 8),
              const OutlinedButton(
                onPressed: null,
                child: Text('Waiting for Admin Verification'),
              ),
            ],
          ),
        );
      case BorrowStatus.depositVerified:
        return _statusColumn(
          message: 'Deposit verified. Meet owner and pick up book.',
          action: FilledButton(
            onPressed: () {
              state.confirmBookReceived(borrowing!.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Book status updated: Sedang Dipinjam.')),
              );
            },
            child: const Text('Confirm Book Received'),
          ),
        );
      case BorrowStatus.bookReceived:
        return _statusColumn(
          message:
              'You have this book. Coordinate the return; the owner confirms its condition.',
          action: const OutlinedButton(
            onPressed: null,
            child: Text('On Loan'),
          ),
        );
      case BorrowStatus.returnedGood:
        return const OutlinedButton(
          onPressed: null,
          child: Text('Returned Good - Waiting Refund'),
        );
      case BorrowStatus.returnedDamaged:
        return const OutlinedButton(
          onPressed: null,
          child: Text('Returned Damaged - Dispute Open'),
        );
      case BorrowStatus.completed:
      case BorrowStatus.cancelled:
        return FilledButton(
          onPressed: () => _goToRequest(context),
          child: const Text('Borrow Book'),
        );
    }
  }

  Widget _statusColumn({
    required String message,
    required Widget action,
    Color? messageColor,
    bool messageBold = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
            color: messageColor,
            fontWeight: messageBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        action,
      ],
    );
  }
}
