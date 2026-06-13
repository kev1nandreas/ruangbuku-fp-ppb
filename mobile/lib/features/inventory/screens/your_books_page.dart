import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/admin_curation_card.dart';
import '../widgets/owner_book_card.dart';
import 'add_book_page.dart';
import '../../../l10n/app_localizations.dart';

class YourBooksPage extends StatefulWidget {
  const YourBooksPage({super.key});

  @override
  State<YourBooksPage> createState() => _YourBooksPageState();
}

class _YourBooksPageState extends State<YourBooksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final isAdmin = state.currentRole == UserRole.admin;

        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

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
                l10n?.adminCuration ?? 'Admin Curation',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => state.fetchBooks(),
              child: pendingBooks.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      EmptyStateView(
                        icon: Icons.check_circle_outline,
                        title: l10n?.allCaughtUp ?? 'All Caught Up!',
                        message: l10n?.noBooksAwaitingCuration ?? 'There are no books awaiting curation approval right now.',
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    itemCount: pendingBooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: RuangBukuSpacing.lg),
                    itemBuilder: (context, index) =>
                        AdminCurationCard(book: pendingBooks[index]),
                  ),
            ),
          );
        }

        // If Lender/Borrower: Your Owned Books Catalog
        final currentUserId = AuthNotifier.instance.user?.id ?? '';
        final myBooks =
            state.books.where((b) => b.ownerId == currentUserId).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.yourBooks ?? 'Your Books',
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
          body: RefreshIndicator(
            onRefresh: () => state.fetchBooks(),
            child: myBooks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    EmptyStateView(
                      icon: Icons.library_books_outlined,
                      title: l10n?.yourLibraryEmpty ?? 'Your library is empty',
                      message: l10n?.haventAddedBooks ?? 'You haven\'t added any books yet. Click the "+" button below to register a book (F-01)!',
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      status: _statusText(state, bk, l10n),
                      imageUrl: bk.imageUrl,
                    );
                  },
                ),
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

  String _statusText(RuangBukuState state, BookModel book, AppLocalizations? l10n) {
    if (book.statusVerifikasi == BookStatus.publicPending) {
      return l10n?.pendingApproval ?? 'Pending Approval';
    } else if (book.statusVerifikasi == BookStatus.publicRejected) {
      return l10n?.rejected ?? 'Rejected';
    } else if (book.statusVerifikasi == BookStatus.private) {
      return l10n?.privateBook ?? 'Private';
    }

    final hasActiveBorrow = state.borrowings.any((b) =>
        b.bookId == book.id &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled);
    return hasActiveBorrow ? (l10n?.onLoan ?? 'On Loan') : (l10n?.available ?? 'Available');
  }
}
