import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        // Determine user greeting based on active role
        String greetingName = 'Alex';
        if (state.currentRole == UserRole.admin) {
          greetingName = 'System Admin';
        } else if (state.currentRole == UserRole.lender) {
          greetingName = 'Lender Alex';
        } else {
          greetingName = 'Borrower Alex';
        }

        // Get public approved books
        final publicBooks = state.books.where((b) => b.isPublic && b.statusVerifikasi == BookStatus.publicApproved).toList();

        // Popular: first 3 public approved books
        final popularBooks = publicBooks.take(3).toList();

        // Recently Added: filtered by search query
        final filteredRecentBooks = publicBooks.where((b) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          return b.title.toLowerCase().contains(query) || b.author.toLowerCase().contains(query);
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
                  backgroundImage: const NetworkImage('https://picsum.photos/seed/user_alex/100/100'),
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
                  padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning, $greetingName', style: textTheme.displayMedium),
                      const SizedBox(height: RuangBukuSpacing.sm),
                      Text(
                        'Find your next read from your community library.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: RuangBukuSpacing.xl),
                      
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear), 
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  }) 
                              : null,
                          hintText: 'Search books or neighbors...',
                          fillColor: RuangBukuColors.surfaceContainerLow,
                          border: OutlineInputBorder(
                            borderRadius: RuangBukuRadius.borderRadiusFull,
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: RuangBukuRadius.borderRadiusFull,
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: RuangBukuRadius.borderRadiusFull,
                            borderSide: const BorderSide(
                              color: RuangBukuColors.primary,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: RuangBukuSpacing.xl,
                            vertical: RuangBukuSpacing.lg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: RuangBukuSpacing.xxl),

                // Popular Near You Carousel (Static filtering, shows top approved)
                if (popularBooks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Popular Near You', style: textTheme.headlineSmall),
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
                      padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                      scrollDirection: Axis.horizontal,
                      itemCount: popularBooks.length,
                      separatorBuilder: (context, index) => const SizedBox(width: RuangBukuSpacing.lg),
                      itemBuilder: (context, index) {
                        final bk = popularBooks[index];
                        return _buildPopularBookCard(
                          context,
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
                  padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                  child: Text('Recently Added', style: textTheme.headlineSmall),
                ),
                const SizedBox(height: RuangBukuSpacing.md),
                
                filteredRecentBooks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                        child: Center(
                          child: Text(
                            'No books found matching "$_searchQuery"',
                            style: textTheme.bodyLarge?.copyWith(color: RuangBukuColors.textSecondary),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRecentBooks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.md),
                        itemBuilder: (context, index) {
                          final bk = filteredRecentBooks[index];
                          
                          // Check lending status dynamically
                          bool isBorrowed = state.borrowings.any((b) => 
                            b.bookId == bk.id && 
                            b.status != BorrowStatus.completed && 
                            b.status != BorrowStatus.cancelled
                          );
                          String statusStr = isBorrowed ? 'On Loan' : 'Available';

                          return _buildRecentBookCard(
                            context,
                            bookId: bk.id,
                            title: bk.title,
                            author: bk.author,
                            addedBy: bk.ownerName,
                            avatarUrl: 'https://picsum.photos/seed/${bk.ownerId}/100/100',
                            imageUrl: bk.imageUrl,
                            status: statusStr,
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

  Widget _buildPopularBookCard(BuildContext context, {required String bookId, required String title, required String author, required String imageUrl}) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowerBookDetailPage(bookId: bookId),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: RuangBukuRadius.borderRadiusBase,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: RuangBukuElevation.level1,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              title,
              style: textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              author,
              style: textTheme.bodyMedium?.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookCard(BuildContext context, {
    required String bookId,
    required String title,
    required String author,
    required String addedBy,
    required String avatarUrl,
    required String imageUrl,
    required String status,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

    final isAvailable = status == 'Available';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowerBookDetailPage(bookId: bookId),
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
              width: 70,
              height: 100,
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
                          color: isAvailable ? semanticColors.success.withValues(alpha: 0.2) : semanticColors.neutralChip.withValues(alpha: 0.2),
                          borderRadius: RuangBukuRadius.borderRadiusSm,
                        ),
                        child: Text(
                          status,
                          style: textTheme.labelSmall?.copyWith(
                            color: isAvailable ? semanticColors.success : RuangBukuColors.textSecondary,
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
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(avatarUrl),
                        backgroundColor: RuangBukuColors.surfaceContainerHigh,
                      ),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      Text(
                        'Added by $addedBy',
                        style: textTheme.bodySmall,
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
