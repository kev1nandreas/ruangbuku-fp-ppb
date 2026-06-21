import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/greeting.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../notifications/screens/notification_page.dart';
import 'user_profile_page.dart';
import '../../discovery/widgets/book_sections.dart';
import '../../../l10n/app_localizations.dart';

class UserHomePage extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const UserHomePage({super.key, this.onNavigateToTab});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isBookOnLoan(RuangBukuState state, String bookId) {
    final book = state.books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => BookModel(
          id: '',
          isbn: '',
          title: '',
          author: '',
          description: '',
          isPublic: false,
          statusVerifikasi: BookStatus.private,
          ownerId: '',
          ownerName: '',
          imageUrl: '',
          distance: '',
          condition: ''),
    );

    if (book.hasActiveBorrowing) return true;

    // Fallback: check our own borrowing lists in case the backend hasn't been
    // deployed yet.
    bool isActive(BorrowModel b) =>
        b.bookId == bookId &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled;

    return state.ownerBorrowings.any(isActive) ||
        state.borrowings.any(isActive);
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
        final auth = AuthNotifier.instance;
        final currentUserId = auth.user?.id ?? 'guest';
        final firstName = auth.user?.name.split(' ').first ?? 'User';

        final publicBooks = state.books
            .where((b) =>
                b.isPublic &&
                b.statusVerifikasi == BookStatus.publicApproved)
            .toList();
        final popularBooks = publicBooks.take(3).toList();
        final recentBooks = publicBooks.where((b) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          return b.title.toLowerCase().contains(query) ||
              b.author.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              ),
            ),
            title: Text(
              'RuangBuku',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: RuangBukuSpacing.lg),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProfilePage()),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(auth.user?.avatarUrl ??
                        'https://picsum.photos/seed/$currentUserId/100/100'),
                    onBackgroundImageError: (error, stack) {},
                    backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([state.fetchBooks(), state.fetchBorrowings()]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: RuangBukuSpacing.marginMobile),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${greetingFor(l10n)} $firstName',
                            style: textTheme.displayMedium),
                        const SizedBox(height: RuangBukuSpacing.sm),
                        Text(
                          l10n?.findNextRead ??
                              'Find your next read from your community library.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: RuangBukuSpacing.xl),
                      ],
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  if (state.isLoadingBooks)
                    const Padding(
                      padding: EdgeInsets.all(RuangBukuSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (popularBooks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: RuangBukuSpacing.marginMobile),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rekomendasi Buku',
                              style: textTheme.headlineSmall),
                          TextButton(
                            onPressed: () => widget.onNavigateToTab?.call(1),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.secondary,
                            ),
                            child: Text(l10n?.seeAll ?? 'See all'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.md),
                    PopularBooksRow(books: popularBooks, genres: state.genres),
                    const SizedBox(height: RuangBukuSpacing.xxl),
                  ],

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: RuangBukuSpacing.marginMobile),
                    child: Text(l10n?.recentlyAdded ?? 'Recently Added',
                        style: textTheme.headlineSmall),
                  ),
                  const SizedBox(height: RuangBukuSpacing.md),

                  if (state.isLoadingBooks)
                    const Padding(
                      padding: EdgeInsets.all(RuangBukuSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (recentBooks.isEmpty)
                    Padding(
                      padding:
                          const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                      child: Center(
                        child: Text(
                          'Belum ada buku terbaru.',
                          style: textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  else
                    RecentBooksList(
                      books: recentBooks,
                      genres: state.genres,
                      isOnLoan: (bk) => _isBookOnLoan(state, bk.id),
                    ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
