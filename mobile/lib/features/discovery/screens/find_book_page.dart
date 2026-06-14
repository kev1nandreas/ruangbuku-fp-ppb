import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/app_filter_chip.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/book_grid_card.dart';
import '../../../l10n/app_localizations.dart';

class FindBookPage extends StatefulWidget {
  const FindBookPage({super.key});

  @override
  State<FindBookPage> createState() => _FindBookPageState();
}

class _FindBookPageState extends State<FindBookPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _filterAvailableOnly = false;
  String _sortOption = 'title';
  List<String> _selectedGenres = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isBookOnLoan(RuangBukuState state, String bookId) {
    final book = state.books.firstWhere((b) => b.id == bookId);
    if (book.hasActiveBorrowing) return true;
    
    // Fallback: check our own borrowing lists in case the backend hasn't been deployed yet
    final isIncoming = state.ownerBorrowings.any((b) => 
        b.bookId == bookId && b.status != BorrowStatus.completed && b.status != BorrowStatus.cancelled);
    if (isIncoming) return true;

    return state.borrowings.any((b) =>
        b.bookId == bookId && b.status != BorrowStatus.completed && b.status != BorrowStatus.cancelled);
  }

  void _showAdvancedFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final genres = RuangBukuState.instance.genres;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  RuangBukuSpacing.xl,
                  RuangBukuSpacing.md,
                  RuangBukuSpacing.xl,
                  RuangBukuSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: RuangBukuSpacing.md),
                        decoration: BoxDecoration(
                          color: RuangBukuColors.outlineVariant,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    Text('Advanced Filter', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: RuangBukuSpacing.lg),
                    Text('Genre', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: RuangBukuSpacing.md),
                    if (genres.isEmpty)
                      const Text('Tidak ada genre tersedia.')
                    else
                      Wrap(
                        spacing: RuangBukuSpacing.sm,
                        children: genres.map((g) {
                          final isSelected = _selectedGenres.contains(g.id);
                          return ChoiceChip(
                            label: Text(g.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  _selectedGenres.add(g.id);
                                } else {
                                  _selectedGenres.remove(g.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: RuangBukuSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {}); // trigger rebuild on FindBookPage
                          Navigator.pop(context);
                        },
                        child: const Text('Terapkan Filter'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
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

          // Advanced genre filter
          if (_selectedGenres.isNotEmpty) {
            // Check if the book has at least one of the selected genres
            if (!b.genreIds.any((id) => _selectedGenres.contains(id))) {
              return false;
            }
          }

          return true;
        }).toList();

        // Sort results
        filteredBooks.sort((a, b) {
          return a.title.compareTo(b.title);
        });

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
              // Search & Filters Section
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
                        onPressed: _showAdvancedFilter,
                      ),
                    ),
                    const SizedBox(height: RuangBukuSpacing.lg),
                    Text(l10n?.booksFound(filteredBooks.length.toString()) ?? '${filteredBooks.length} Books Found',
                        style: textTheme.headlineSmall),
                  ],
                ),
              ),

              // Results Grid
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => state.fetchBooks(),
                  child: state.isLoadingBooks
                    ? const Center(child: CircularProgressIndicator())
                    : filteredBooks.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: RuangBukuSpacing.huge),
                              Center(
                                child: Text(
                                  _searchQuery.isEmpty
                                      ? 'Belum ada buku tersedia.'
                                      : (l10n?.noBooksFound(_searchQuery) ?? 'No books found matching "$_searchQuery"'),
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
                          String genreName = '-';
                          if (bk.genreIds.isNotEmpty) {
                            final genreId = bk.genreIds.first;
                            final match = state.genres.where((g) => g.id == genreId);
                            if (match.isNotEmpty) {
                              genreName = match.first.name;
                            }
                          }

                          return BookGridCard(
                            bookId: bk.id,
                            title: bk.title,
                            author: bk.author,
                            imageUrl: bk.imageUrl,
                            isAvailable: !_isBookOnLoan(state, bk.id),
                            genre: genreName,
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
