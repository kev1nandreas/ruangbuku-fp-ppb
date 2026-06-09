import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../widgets/admin_curation_card.dart';
import '../widgets/owner_book_card.dart';
import 'add_book_page.dart';

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
          final pendingBooks = state.books
              .where((b) =>
                  b.isPublic &&
                  b.statusVerifikasi == BookStatus.publicPending)
              .toList();

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
                ? const EmptyStateView(
                    icon: Icons.check_circle_outline,
                    title: 'All Caught Up!',
                    message:
                        'There are no books awaiting curation approval right now.',
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    itemCount: pendingBooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: RuangBukuSpacing.lg),
                    itemBuilder: (context, index) =>
                        AdminCurationCard(book: pendingBooks[index]),
                  ),
          );
        }

        // If Lender/Borrower: Your Owned Books Catalog
        final myBooks =
            state.books.where((b) => b.ownerId == 'user_alex').toList();

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
              ? const EmptyStateView(
                  icon: Icons.library_books_outlined,
                  title: 'Your library is empty',
                  message:
                      'You haven\'t added any books yet. Click the "+" button below to register a book (F-01)!',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: myBooks.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: RuangBukuSpacing.lg),
                  itemBuilder: (context, index) {
                    final bk = myBooks[index];
                    return OwnerBookCard(
                      bookId: bk.id,
                      title: bk.title,
                      author: bk.author,
                      status: _statusText(state, bk),
                      imageUrl: bk.imageUrl,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBookPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  String _statusText(RuangBukuState state, BookModel book) {
    if (book.statusVerifikasi == BookStatus.publicPending) {
      return 'Pending Approval';
    } else if (book.statusVerifikasi == BookStatus.publicRejected) {
      return 'Rejected';
    } else if (book.statusVerifikasi == BookStatus.private) {
      return 'Private';
    }

    final hasActiveBorrow = state.borrowings.any((b) =>
        b.bookId == book.id &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled);
    return hasActiveBorrow ? 'On Loan' : 'Available';
  }
}
