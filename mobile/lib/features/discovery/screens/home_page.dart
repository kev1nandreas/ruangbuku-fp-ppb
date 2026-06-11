import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/popular_book_card.dart';
import '../widgets/recent_book_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isBookOnLoan(RuangBukuState state, String bookId) {
    return state.borrowings.any((b) =>
        b.bookId == bookId &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        final auth = AuthNotifier.instance;
        final currentUserId = auth.user?.id ?? 'guest';
        final firstName = auth.user?.name.split(' ').first ?? 'User';

        // Determine user greeting based on active role
        String greetingName = firstName;
        if (state.currentRole == UserRole.admin) {
          greetingName = 'Admin $firstName';
        } else if (state.currentRole == UserRole.lender) {
          greetingName = 'Lender $firstName';
        } else {
          greetingName = 'Borrower $firstName';
        }

        // Get public approved books
        final publicBooks = state.books
            .where((b) =>
                b.isPublic && b.statusVerifikasi == BookStatus.publicApproved)
            .toList();

        // Popular: first 3 public approved books
        final popularBooks = publicBooks.take(3).toList();

        // Recently Added: filtered by search query
        final filteredRecentBooks = publicBooks.where((b) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          return b.title.toLowerCase().contains(query) ||
              b.author.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
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
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/$currentUserId/100/100'),
                  backgroundColor: RuangBukuColors.surfaceContainerHigh,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: RuangBukuSpacing.marginMobile),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning, $greetingName',
                          style: textTheme.displayMedium),
                      const SizedBox(height: RuangBukuSpacing.sm),
                      Text(
                        'Find your next read from your community library.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: RuangBukuSpacing.xl),
                      AppSearchField(
                        controller: _searchController,
                        onChanged: (val) =>
                            setState(() => _searchQuery = val),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: RuangBukuSpacing.xxl),

                // Popular Near You Carousel
                if (popularBooks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: RuangBukuSpacing.marginMobile),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Popular Near You',
                            style: textTheme.headlineSmall),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: RuangBukuColors.accent,
                          ),
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.md),
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: RuangBukuSpacing.marginMobile),
                      scrollDirection: Axis.horizontal,
                      itemCount: popularBooks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: RuangBukuSpacing.lg),
                      itemBuilder: (context, index) {
                        final bk = popularBooks[index];
                        return PopularBookCard(
                          bookId: bk.id,
                          title: bk.title,
                          author: bk.author,
                          imageUrl: bk.imageUrl,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                ],

                // Recently Added List
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: RuangBukuSpacing.marginMobile),
                  child: Text('Recently Added', style: textTheme.headlineSmall),
                ),
                const SizedBox(height: RuangBukuSpacing.md),

                filteredRecentBooks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(
                            RuangBukuSpacing.marginMobile),
                        child: Center(
                          child: Text(
                            'No books found matching "$_searchQuery"',
                            style: textTheme.bodyLarge?.copyWith(
                                color: RuangBukuColors.textSecondary),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: RuangBukuSpacing.marginMobile),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRecentBooks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: RuangBukuSpacing.md),
                        itemBuilder: (context, index) {
                          final bk = filteredRecentBooks[index];
                          return RecentBookCard(
                            bookId: bk.id,
                            title: bk.title,
                            author: bk.author,
                            addedBy: bk.ownerName,
                            avatarUrl:
                                'https://picsum.photos/seed/${bk.ownerId}/100/100',
                            imageUrl: bk.imageUrl,
                            isAvailable: !_isBookOnLoan(state, bk.id),
                          );
                        },
                      ),
                const SizedBox(height: RuangBukuSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }
}
