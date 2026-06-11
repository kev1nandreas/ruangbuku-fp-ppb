import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/app_filter_chip.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/book_grid_card.dart';

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
        final currentUserId = AuthNotifier.instance.user?.id ?? 'guest';

        final publicBooks = state.books
            .where((b) =>
                b.isPublic && b.statusVerifikasi == BookStatus.publicApproved)
            .toList();

        // Apply filters
        final filteredBooks = publicBooks.where((b) {
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final matchesTitle = b.title.toLowerCase().contains(query);
            final matchesAuthor = b.author.toLowerCase().contains(query);
            if (!matchesTitle && !matchesAuthor) return false;
          }

          if (_filterAvailableOnly && _isBookOnLoan(state, b.id)) return false;

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
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/$currentUserId/100/100'),
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
                    AppSearchField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      idleSuffixIcon: const Icon(Icons.tune),
                    ),
                    const SizedBox(height: RuangBukuSpacing.lg),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AppFilterChip(
                            label: 'All Categories',
                            isSelected:
                                !_filterAvailableOnly && !_filterWithin5km,
                            onTap: () => setState(() {
                              _filterAvailableOnly = false;
                              _filterWithin5km = false;
                            }),
                          ),
                          const SizedBox(width: RuangBukuSpacing.sm),
                          AppFilterChip(
                            label: 'Available Now',
                            isSelected: _filterAvailableOnly,
                            onTap: () => setState(() =>
                                _filterAvailableOnly = !_filterAvailableOnly),
                          ),
                          const SizedBox(width: RuangBukuSpacing.sm),
                          AppFilterChip(
                            label: 'Within 5km',
                            isSelected: _filterWithin5km,
                            onTap: () => setState(
                                () => _filterWithin5km = !_filterWithin5km),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${filteredBooks.length} Books Found',
                            style: textTheme.headlineSmall),
                        Row(
                          children: [
                            Text('Sort by Distance',
                                style: textTheme.labelLarge),
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
                          style: textTheme.bodyLarge?.copyWith(
                              color: RuangBukuColors.textSecondary),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: RuangBukuSpacing.marginMobile),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: RuangBukuSpacing.lg,
                          mainAxisSpacing: RuangBukuSpacing.lg,
                        ),
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final bk = filteredBooks[index];
                          return BookGridCard(
                            bookId: bk.id,
                            title: bk.title,
                            author: bk.author,
                            distance: bk.distance,
                            imageUrl: bk.imageUrl,
                            isAvailable: !_isBookOnLoan(state, bk.id),
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
}
