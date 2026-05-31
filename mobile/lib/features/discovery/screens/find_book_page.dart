import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';

class FindBookPage extends StatefulWidget {
  const FindBookPage({super.key});

  @override
  State<FindBookPage> createState() => _FindBookPageState();
}

class _FindBookPageState extends State<FindBookPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _filterAvailableOnly = false;
  bool _filterWithin5km = false;

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

        // Get all public approved books
        final publicBooks = state.books.where((b) => b.isPublic && b.statusVerifikasi == BookStatus.publicApproved).toList();

        // Apply filters
        final filteredBooks = publicBooks.where((b) {
          // 1. Search Query
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final matchesTitle = b.title.toLowerCase().contains(query);
            final matchesAuthor = b.author.toLowerCase().contains(query);
            if (!matchesTitle && !matchesAuthor) return false;
          }

          // Check if currently borrowed
          final isBorrowed = state.borrowings.any((borrow) => 
            borrow.bookId == b.id && 
            borrow.status != BorrowStatus.completed && 
            borrow.status != BorrowStatus.cancelled
          );

          // 2. Available Filter
          if (_filterAvailableOnly && isBorrowed) return false;

          // 3. Distance Filter (simulate 5km based on text)
          if (_filterWithin5km) {
            try {
              final distNum = double.parse(b.distance.split(' ').first);
              if (distNum > 5.0) return false;
            } catch (_) {
              // Ignore parse errors
            }
          }

          return true;
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Filters Section
              Padding(
                padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                },
                              )
                            : const Icon(Icons.tune),
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
                    const SizedBox(height: RuangBukuSpacing.lg),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterAvailableOnly = false;
                                _filterWithin5km = false;
                              });
                            },
                            child: _buildFilterChip(
                              context, 
                              'All Categories', 
                              isSelected: !_filterAvailableOnly && !_filterWithin5km
                            ),
                          ),
                          const SizedBox(width: RuangBukuSpacing.sm),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterAvailableOnly = !_filterAvailableOnly;
                              });
                            },
                            child: _buildFilterChip(
                              context, 
                              'Available Now', 
                              isSelected: _filterAvailableOnly
                            ),
                          ),
                          const SizedBox(width: RuangBukuSpacing.sm),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterWithin5km = !_filterWithin5km;
                              });
                            },
                            child: _buildFilterChip(
                              context, 
                              'Within 5km', 
                              isSelected: _filterWithin5km
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filteredBooks.length} Books Found', style: textTheme.headlineSmall),
                        Row(
                          children: [
                            Text('Sort by Distance', style: textTheme.labelLarge),
                            const Icon(Icons.keyboard_arrow_down, size: 20),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Results Grid
              Expanded(
                child: filteredBooks.isEmpty
                    ? Center(
                        child: Text(
                          'No books found matching the filters.',
                          style: textTheme.bodyLarge?.copyWith(color: RuangBukuColors.textSecondary),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: RuangBukuSpacing.lg,
                          mainAxisSpacing: RuangBukuSpacing.lg,
                        ),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final bk = filteredBooks[index];
                          
                          // Check borrowing status dynamically
                          final isBorrowed = state.borrowings.any((borrow) => 
                            borrow.bookId == bk.id && 
                            borrow.status != BorrowStatus.completed && 
                            borrow.status != BorrowStatus.cancelled
                          );
                          final statusStr = isBorrowed ? 'On Loan' : 'Available';

                          return _buildBookGridCard(
                            context,
                            bookId: bk.id,
                            title: bk.title,
                            author: bk.author,
                            distance: bk.distance,
                            status: statusStr,
                            imageUrl: bk.imageUrl,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, {required bool isSelected}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.lg, vertical: RuangBukuSpacing.sm),
      decoration: BoxDecoration(
        color: isSelected ? RuangBukuColors.primary : RuangBukuColors.surfaceContainerLow,
        borderRadius: RuangBukuRadius.borderRadiusFull,
        border: Border.all(
          color: isSelected ? RuangBukuColors.primary : RuangBukuColors.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            Icon(Icons.check, size: 16, color: RuangBukuColors.onPrimary),
            const SizedBox(width: RuangBukuSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected ? RuangBukuColors.onPrimary : RuangBukuColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGridCard(BuildContext context, {
    required String bookId,
    required String title,
    required String author,
    required String distance,
    required String status,
    required String imageUrl,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Status Badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: RuangBukuSpacing.sm,
                    right: RuangBukuSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable ? semanticColors.success.withValues(alpha: 0.9) : RuangBukuColors.surfaceContainerHigh.withValues(alpha: 0.9),
                        borderRadius: RuangBukuRadius.borderRadiusSm,
                      ),
                      child: Text(
                        status,
                        style: textTheme.labelSmall?.copyWith(
                          color: isAvailable ? RuangBukuColors.textDeep : RuangBukuColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(RuangBukuSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: RuangBukuSpacing.xs),
                  Text(
                    author,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: RuangBukuSpacing.md),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: RuangBukuColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: textTheme.bodySmall?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
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
