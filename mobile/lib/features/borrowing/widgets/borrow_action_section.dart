import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../screens/request_borrow_page.dart';
import 'return_inspection_dialog.dart';
import '../../auth/domain/auth_notifier.dart';

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
            onPressed: () {
              state.uploadProofOfDeposit(borrowing!.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Deposit receipt uploaded successfully (F-02)!')),
              );
            },
            child: const Text('Upload Deposit Proof (Rp. 50,000)'),
          ),
        );
      case BorrowStatus.depositUploaded:
        return const OutlinedButton(
          onPressed: null,
          child: Text('Waiting for Admin Verification'),
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
          message: 'You have this book. Coordinate via WA to return.',
          action: FilledButton(
            onPressed: () => showReturnInspectionDialog(context, borrowing!),
            child: const Text('Return Book'),
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
