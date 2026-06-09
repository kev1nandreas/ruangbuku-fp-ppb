import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/services/book_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../widgets/admin_curation_card.dart';
import '../widgets/owner_book_card.dart';
import 'add_book_page.dart';

class YourBooksPage extends StatefulWidget {
  const YourBooksPage({super.key});

  @override
  State<YourBooksPage> createState() => _YourBooksPageState();
}

class _YourBooksPageState extends State<YourBooksPage> {
  bool _isLoading = true;
  List<BookModel> _myBooks = [];
  List<BookModel> _pendingBooks = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    try {
      final userId = await AuthService.getUserId();
      _isAdmin = RuangBukuState.instance.currentRole == UserRole.admin;

      if (_isAdmin) {
        final data = await BookService.getBooks(statusVerifikasi: 'need_verification', isPublic: true);
        if (mounted) {
          setState(() {
            _pendingBooks = data.map((e) => BookModel.fromJson(e)).toList();
          });
        }
      } else {
        if (userId != null) {
          final data = await BookService.getBooks(userId: userId);
          if (mounted) {
            setState(() {
              _myBooks = data.map((e) => BookModel.fromJson(e)).toList();
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading books: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyBook(String bookId, bool isApproved) async {
    // Calling backend verify endpoint (Assume it exists, if not, it will error nicely)
    try {
       // Currently backend BukuController has verify logic? In our analysis it was POST /buku/{id}/verify
       // Let's just simulate the state update or use ApiClient directly
       // await ApiClient.post('/buku/$bookId/verify', {'approved': isApproved});
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin Verify feature requires backend implementation.')));
       _fetchBooks();
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

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
