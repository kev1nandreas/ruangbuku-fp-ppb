import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../inventory/widgets/owner_book_card.dart';
import '../../inventory/screens/add_book_page.dart';
import '../../../l10n/app_localizations.dart';

class UserBooksPage extends StatefulWidget {
  const UserBooksPage({super.key});

  @override
  State<UserBooksPage> createState() => _UserBooksPageState();
}

class _UserBooksPageState extends State<UserBooksPage> {
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

        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

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
                      status: _statusText(state, bk),
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

  String _statusText(RuangBukuState state, BookModel book) {
    if (book.statusVerifikasi == BookStatus.publicPending) {
      return 'pending';
    } else if (book.statusVerifikasi == BookStatus.publicRejected) {
      return 'rejected';
    } else if (book.statusVerifikasi == BookStatus.private) {
      return 'private';
    }

    final hasActiveBorrow = state.ownerBorrowings.any((b) =>
        b.bookId == book.id &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled);
    return hasActiveBorrow ? 'on_loan' : 'available';
  }
}
