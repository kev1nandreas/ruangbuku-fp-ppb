import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import 'add_book_page.dart';
import 'edit_book_page.dart';
import 'owner_book_detail_page.dart';

class YourBooksPage extends StatelessWidget {
  const YourBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final isAdmin = state.currentRole == UserRole.admin;

        // If Admin: Curation Dashboard
        if (isAdmin) {
          final pendingBooks = state.books.where((b) => b.isPublic && b.statusVerifikasi == BookStatus.publicPending).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Admin Curation',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: pendingBooks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline, size: 64, color: RuangBukuColors.primary),
                          const SizedBox(height: RuangBukuSpacing.lg),
                          Text('All Caught Up!', style: textTheme.titleLarge),
                          const SizedBox(height: RuangBukuSpacing.sm),
                          Text(
                            'There are no books awaiting curation approval right now.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    itemCount: pendingBooks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.lg),
                    itemBuilder: (context, index) {
                      final bk = pendingBooks[index];
                      return _buildAdminCurationCard(context, bk);
                    },
                  ),
          );
        }

        // If Lender/Borrower: Your Owned Books Catalog
        final myBooks = state.books.where((b) => b.ownerId == 'user_alex').toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Your Books',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {},
              ),
            ],
          ),
          body: myBooks.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.library_books_outlined, size: 64, color: RuangBukuColors.primary),
                        const SizedBox(height: RuangBukuSpacing.lg),
                        Text('Your library is empty', style: textTheme.titleLarge),
                        const SizedBox(height: RuangBukuSpacing.sm),
                        Text(
                          'You haven\'t added any books yet. Click the "+" button below to register a book (F-01)!',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: myBooks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.lg),
                  itemBuilder: (context, index) {
                    final bk = myBooks[index];

                    // Check status string
                    String statusText = 'Available';
                    if (bk.statusVerifikasi == BookStatus.publicPending) {
                      statusText = 'Pending Approval';
                    } else if (bk.statusVerifikasi == BookStatus.publicRejected) {
                      statusText = 'Rejected';
                    } else if (bk.statusVerifikasi == BookStatus.private) {
                      statusText = 'Private';
                    } else {
                      // Check if there is an active borrowing
                      final hasActiveBorrow = state.borrowings.any((b) => 
                        b.bookId == bk.id && 
                        b.status != BorrowStatus.completed && 
                        b.status != BorrowStatus.cancelled
                      );
                      statusText = hasActiveBorrow ? 'On Loan' : 'Available';
                    }

                    return _buildOwnerBookCard(
                      context,
                      bookId: bk.id,
                      title: bk.title,
                      author: bk.author,
                      status: statusText,
                      imageUrl: bk.imageUrl,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBookPage(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildAdminCurationCard(BuildContext context, BookModel book) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final state = RuangBukuState.instance;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        boxShadow: RuangBukuElevation.level1,
        border: Border.all(
          color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 105,
            decoration: BoxDecoration(
              borderRadius: RuangBukuRadius.borderRadiusBase,
              image: DecorationImage(
                image: NetworkImage(book.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: RuangBukuSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(book.author, style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary)),
                const SizedBox(height: 4),
                Text('ISBN: ${book.isbn}', style: textTheme.labelSmall),
                Text('Owner: ${book.ownerName}', style: textTheme.bodySmall),
                const SizedBox(height: RuangBukuSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                          foregroundColor: RuangBukuColors.error,
                          side: const BorderSide(color: RuangBukuColors.error),
                        ),
                        onPressed: () => state.verifyBook(book.id, false),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: RuangBukuSpacing.md),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                          backgroundColor: RuangBukuColors.primary,
                        ),
                        onPressed: () => state.verifyBook(book.id, true),
                        child: const Text('Approve'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerBookCard(BuildContext context, {
    required String bookId,
    required String title,
    required String author,
    required String status,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;
    final state = RuangBukuState.instance;

    final isAvailable = status == 'Available';
    final isPending = status == 'Pending Approval';
    final isRejected = status == 'Rejected';

    Color badgeColor = semanticColors.neutralChip.withValues(alpha: 0.2);
    Color textColor = RuangBukuColors.textSecondary;
    if (isAvailable) {
      badgeColor = semanticColors.success.withValues(alpha: 0.2);
      textColor = semanticColors.success;
    } else if (isPending) {
      badgeColor = Colors.orange.withValues(alpha: 0.2);
      textColor = Colors.orange;
    } else if (isRejected) {
      badgeColor = Colors.red.withValues(alpha: 0.2);
      textColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerBookDetailPage(bookId: bookId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: RuangBukuRadius.borderRadiusLg,
          boxShadow: RuangBukuElevation.level1,
          border: Border.all(
            color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(RuangBukuSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: RuangBukuRadius.borderRadiusBase,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: RuangBukuSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: RuangBukuRadius.borderRadiusSm,
                        ),
                        child: Text(
                          status,
                          style: textTheme.labelSmall?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RuangBukuSpacing.xs),
                  Text(
                    author,
                    style: textTheme.bodyMedium?.copyWith(
                      color: RuangBukuColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.md),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(bookId: bookId),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: RuangBukuColors.error,
                          side: const BorderSide(color: RuangBukuColors.error, width: 1.5),
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.md),
                        ),
                        onPressed: () {
                          state.deleteBook(bookId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book removed from library')),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
