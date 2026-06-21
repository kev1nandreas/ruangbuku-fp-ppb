import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_search_field.dart';
import '../widgets/book_grid_card.dart';
import '../widgets/book_sections.dart';
import '../widgets/advanced_filter_sheet.dart';
import '../../../l10n/app_localizations.dart';

class FindBookPage extends StatefulWidget {
  const FindBookPage({super.key});

  @override
  State<FindBookPage> createState() => _FindBookPageState();
}

class _FindBookPageState extends State<FindBookPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final bool _filterAvailableOnly = false;
  final List<String> _selectedGenres = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isBookOnLoan(RuangBukuState state, String bookId) {
    final book = state.books.firstWhere((b) => b.id == bookId);
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
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        final publicBooks = state.books
            .where((b) =>
                b.isPublic &&
                b.statusVerifikasi == BookStatus.publicApproved)
            .toList();

        final filteredBooks = publicBooks.where((b) {
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            if (!b.title.toLowerCase().contains(query) &&
                !b.author.toLowerCase().contains(query)) {
              return false;
            }
          }
          if (_filterAvailableOnly && _isBookOnLoan(state, b.id)) return false;
          if (_selectedGenres.isNotEmpty &&
              !b.genreIds.any((id) => _selectedGenres.contains(id))) {
            return false;
          }
          return true;
        }).toList()
          ..sort((a, b) => a.title.compareTo(b.title));

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'RuangBuku',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSearchField(
                      controller: _searchController,
                      hintText: 'Mau baca apa hari ini',
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      idleSuffixIcon: IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () => showAdvancedFilterSheet(
                          context,
                          selectedGenres: _selectedGenres,
                          onApply: () => setState(() {}),
                        ),
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.lg),
                    Text(
                        l10n?.booksFound(filteredBooks.length.toString()) ??
                            '${filteredBooks.length} Books Found',
                        style: textTheme.headlineSmall),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => state.fetchBooks(),
                  child: state.isLoadingBooks
                      ? const Center(child: CircularProgressIndicator())
                      : filteredBooks.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: RuangBukuSpacing.huge),
                                Center(
                                  child: Text(
                                    _searchQuery.isEmpty
                                        ? 'Belum ada buku tersedia.'
                                        : (l10n?.noBooksFound(_searchQuery) ??
                                            'No books found matching "$_searchQuery"'),
                                    style: textTheme.bodyLarge?.copyWith(
                                        color: RuangBukuColors.textSecondary),
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
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
                                  imageUrl: bk.imageUrl,
                                  isAvailable: !_isBookOnLoan(state, bk.id),
                                  genre: genreNameFor(bk, state.genres),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
