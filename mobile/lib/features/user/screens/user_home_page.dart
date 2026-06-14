import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../notifications/screens/notification_page.dart';
import 'user_profile_page.dart';
import '../../discovery/widgets/popular_book_card.dart';
import '../../discovery/widgets/recent_book_card.dart';
import '../../../l10n/app_localizations.dart';

class UserHomePage extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const UserHomePage({
    super.key,
    this.onNavigateToTab,
  });

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
    final book = state.books.firstWhere((b) => b.id == bookId, orElse: () => BookModel(
      id: '', isbn: '', title: '', author: '', description: '', isPublic: false, 
      statusVerifikasi: BookStatus.private, ownerId: '', ownerName: '', imageUrl: '', 
      distance: '', condition: ''));
      
    if (book.hasActiveBorrowing) return true;
    
    // Fallback: check our own borrowing lists in case the backend hasn't been deployed yet
    final isIncoming = state.ownerBorrowings.any((b) => 
        b.bookId == bookId && b.status != BorrowStatus.completed && b.status != BorrowStatus.cancelled);
    if (isIncoming) return true;

    return state.borrowings.any((b) =>
        b.bookId == bookId && b.status != BorrowStatus.completed && b.status != BorrowStatus.cancelled);
  }

  String _getGreeting(AppLocalizations? l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l10n?.goodMorning ?? 'Good morning,';
    } else if (hour < 15) {
      return l10n?.goodAfternoonSiang ?? 'Good afternoon,';
    } else if (hour < 18) {
      return l10n?.goodAfternoonSore ?? 'Good afternoon,';
    } else {
      return l10n?.goodEvening ?? 'Good evening,';
    }
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

        String greetingName = firstName;

        final publicBooks = state.books
            .where((b) =>
                b.isPublic && b.statusVerifikasi == BookStatus.publicApproved)
            .toList();

        final popularBooks = publicBooks.take(3).toList();

        final filteredRecentBooks = publicBooks.where((b) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          return b.title.toLowerCase().contains(query) ||
              b.author.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        auth.user?.avatarUrl ?? 'https://picsum.photos/seed/$currentUserId/100/100'),
                    onBackgroundImageError: (error, stack) {},
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                state.fetchBooks(),
                state.fetchBorrowings(),
              ]);
            },
            child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: RuangBukuSpacing.marginMobile),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_getGreeting(l10n)} $greetingName',
                          style: textTheme.displayMedium),
                      const SizedBox(height: RuangBukuSpacing.sm),
                      Text(
                        l10n?.findNextRead ?? 'Find your next read from your community library.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                          onPressed: () {
                            if (widget.onNavigateToTab != null) {
                              widget.onNavigateToTab!(1); // index 1 is "Cari Buku" / Find Book
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(l10n?.seeAll ?? 'See all'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.md),
                  SizedBox(
                    height: 300,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: RuangBukuSpacing.marginMobile),
                      scrollDirection: Axis.horizontal,
                      itemCount: popularBooks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: RuangBukuSpacing.lg),
                      itemBuilder: (context, index) {
                        final bk = popularBooks[index];
                        String genreName = '-';
                        if (bk.genreIds.isNotEmpty) {
                          final genreId = bk.genreIds.first;
                          final match = state.genres.where((g) => g.id == genreId);
                          if (match.isNotEmpty) {
                            genreName = match.first.name;
                          }
                        }
                        return PopularBookCard(
                          bookId: bk.id,
                          title: bk.title,
                          author: bk.author,
                          imageUrl: bk.imageUrl,
                          genre: genreName,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                ],

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: RuangBukuSpacing.marginMobile),
                  child: Text(l10n?.recentlyAdded ?? 'Recently Added', style: textTheme.headlineSmall),
                ),
                const SizedBox(height: RuangBukuSpacing.md),

                if (state.isLoadingBooks)
                  const Padding(
                    padding: EdgeInsets.all(RuangBukuSpacing.xl),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filteredRecentBooks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    child: Center(
                      child: Text(
                        'Belum ada buku terbaru.',
                        style: textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: RuangBukuSpacing.marginMobile),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRecentBooks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: RuangBukuSpacing.md),
                    itemBuilder: (context, index) {
                      final bk = filteredRecentBooks[index];
                      String genreName = '-';
                      if (bk.genreIds.isNotEmpty) {
                        final genreId = bk.genreIds.first;
                        final match = state.genres.where((g) => g.id == genreId);
                        if (match.isNotEmpty) {
                          genreName = match.first.name;
                        }
                      }
                      return RecentBookCard(
                        bookId: bk.id,
                        title: bk.title,
                        author: bk.author,
                        addedBy: bk.ownerName,
                        avatarUrl:
                            'https://picsum.photos/seed/${bk.ownerId}/100/100',
                        imageUrl: bk.imageUrl,
                        isAvailable: !_isBookOnLoan(state, bk.id),
                        genre: genreName,
                      );
                    },
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
