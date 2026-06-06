import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import 'request_borrow_page.dart';

class BorrowerBookDetailPage extends StatelessWidget {
  final String bookId;

  const BorrowerBookDetailPage({super.key, required this.bookId});

  void _showReturnDialog(BuildContext context, BorrowModel borrowing) {
    final TextEditingController damageController = TextEditingController();
    final state = RuangBukuState.instance;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book Return Inspection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please inspect the returned book. Is the book returned in good condition (A) or is it damaged/cacat (B)?',
                style: TextStyle(height: 1.4),
              ),
              const SizedBox(height: RuangBukuSpacing.lg),
              TextField(
                controller: damageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Damage Details (Only if Damaged)',
                  hintText: 'e.g., Cover ripped, pages missing...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: RuangBukuColors.error,
                side: const BorderSide(color: RuangBukuColors.error),
              ),
              onPressed: () {
                final desc = damageController.text.trim();
                state.returnBook(
                  borrowing.id,
                  isGoodCondition: false,
                  damageDescription: desc.isEmpty ? 'Halaman terlipat/sobek' : desc,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book marked as DAMAGED. Dispute sent to Admin (F-03).')),
                );
              },
              child: const Text('Damaged (B)'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: RuangBukuColors.primary,
              ),
              onPressed: () {
                state.returnBook(borrowing.id, isGoodCondition: true);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book returned in GOOD condition. Refund pending (F-03).')),
                );
              },
              child: const Text('Good (A)'),
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
        
        final book = state.books.firstWhere(
          (b) => b.id == bookId,
          orElse: () => BookModel(
            id: '',
            isbn: '',
            title: 'Not Found',
            author: 'Unknown',
            description: '',
            isPublic: false,
            statusVerifikasi: BookStatus.private,
            ownerId: '',
            ownerName: 'N/A',
            imageUrl: 'https://picsum.photos/200/300',
            distance: '',
            condition: 'Good',
          ),
        );

        // Find active borrowing by user_alex for this book
        final activeBorrowIndex = state.borrowings.indexWhere((b) => 
          b.bookId == bookId && 
          b.status != BorrowStatus.completed && 
          b.status != BorrowStatus.cancelled
        );

        BorrowModel? activeBorrow;
        if (activeBorrowIndex != -1) {
          activeBorrow = state.borrowings[activeBorrowIndex];
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Book Details',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                Center(
                  child: Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: RuangBukuRadius.borderRadiusLg,
                      image: DecorationImage(
                        image: NetworkImage(book.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: RuangBukuElevation.level2,
                    ),
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xl),

                // Title & Author
                Text(
                  book.title,
                  style: textTheme.displayMedium,
                ),
                const SizedBox(height: RuangBukuSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.author,
                      style: textTheme.titleMedium?.copyWith(
                        color: RuangBukuColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Owner: ${book.ownerName}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RuangBukuSpacing.lg),

                // Ratings & Details
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: RuangBukuSpacing.xs),
                    Text(
                      '4.5',
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(width: RuangBukuSpacing.md),
                    Text(
                      '(128 Reviews)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: RuangBukuColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: RuangBukuColors.surfaceContainerLow,
                        borderRadius: RuangBukuRadius.borderRadiusSm,
                      ),
                      child: Text(
                        'Copy: ${book.condition}',
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RuangBukuSpacing.xxl),

                // Synopsis
                Text('Synopsis', style: textTheme.headlineSmall),
                const SizedBox(height: RuangBukuSpacing.md),
                Text(
                  book.description,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: RuangBukuColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: RuangBukuColors.shadowTint.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: _buildActionButtons(context, state, book, activeBorrow),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, RuangBukuState state, BookModel book, BorrowModel? borrowing) {
    // If own book
    if (book.ownerId == 'user_alex') {
      return OutlinedButton(
        onPressed: null,
        child: const Text('This is your own book'),
      );
    }

    if (borrowing == null) {
      // Check if book is already borrowed by someone else
      final isAlreadyBorrowed = state.borrowings.any((b) => 
        b.bookId == book.id && 
        b.status != BorrowStatus.completed && 
        b.status != BorrowStatus.cancelled
      );

      if (isAlreadyBorrowed) {
        return const OutlinedButton(
          onPressed: null,
          child: Text('Book Currently on Loan'),
        );
      }

      return FilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestBorrowPage(bookId: book.id),
            ),
          );
        },
        child: const Text('Borrow Book'),
      );
    }

    // Handle status lifecycle
    switch (borrowing.status) {
      case BorrowStatus.requested:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Waiting for Lender approval...',
              style: TextStyle(color: RuangBukuColors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: null,
              child: const Text('Requested'),
            ),
          ],
        );
      case BorrowStatus.waitingDeposit:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lender approved! Please pay the deposit.', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                state.uploadProofOfDeposit(borrowing.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deposit receipt uploaded successfully (F-02)!')),
                );
              },
              child: const Text('Upload Deposit Proof (Rp. 50,000)'),
            ),
          ],
        );
      case BorrowStatus.depositUploaded:
        return const OutlinedButton(
          onPressed: null,
          child: Text('Waiting for Admin Verification'),
        );
      case BorrowStatus.depositVerified:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Deposit verified. Meet owner and pick up book.', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                state.confirmBookReceived(borrowing.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book status updated: Sedang Dipinjam.')),
                );
              },
              child: const Text('Confirm Book Received'),
            ),
          ],
        );
      case BorrowStatus.bookReceived:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have this book. Coordinate via WA to return.', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _showReturnDialog(context, borrowing),
              child: const Text('Return Book'),
            ),
          ],
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestBorrowPage(bookId: book.id),
              ),
            );
          },
          child: const Text('Borrow Book'),
        );
    }
  }
}
