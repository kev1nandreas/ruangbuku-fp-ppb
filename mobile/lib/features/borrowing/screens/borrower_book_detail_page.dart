import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../discovery/domain/book_notifier.dart';
import '../widgets/borrow_action_section.dart';
import '../../../l10n/app_localizations.dart';

class BorrowerBookDetailPage extends StatefulWidget {
  final String bookId;

  const BorrowerBookDetailPage({super.key, required this.bookId});

  @override
  State<BorrowerBookDetailPage> createState() => _BorrowerBookDetailPageState();
}

class _BorrowerBookDetailPageState extends State<BorrowerBookDetailPage> {
  BookModel? _book;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    // Refresh borrowings so the action section reflects any pending request
    // for this book and we don't show a stale "Borrow Book" button. Deferred
    // to after the frame because it calls notifyListeners() synchronously,
    // which would mark the ListenableBuilder dirty during the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBorrowings();
    });

    // Seed with cached book (from the list) so something shows immediately.
    final cached = RuangBukuState.instance.books
        .where((b) => b.id == widget.bookId)
        .cast<BookModel?>()
        .firstWhere((_) => true, orElse: () => null);

    if (cached != null && mounted) {
      setState(() => _book = cached);
    }

    final detail = await BookNotifier.instance.fetchBookDetail(widget.bookId);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (detail != null) {
        _book = detail;
      } else if (_book == null) {
        // Will be replaced in UI by l10n
        _error = 'Failed to load book detail. Check your connection.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n?.bookDetails ?? 'Book Details',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(context, textTheme),
    );
  }

  Widget _buildBody(BuildContext context, TextTheme textTheme) {
    final l10n = AppLocalizations.of(context);

    if (_book == null && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_book == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(RuangBukuSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error != null ? (l10n?.failedLoadBook ?? _error!) : (l10n?.bookNotFound ?? 'Book not found.'),
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge
                    ?.copyWith(color: RuangBukuColors.textSecondary),
              ),
              const SizedBox(height: RuangBukuSpacing.lg),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadDetail();
                },
                child: Text(l10n?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final book = _book!;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final currentUserId = AuthNotifier.instance.user?.id ?? '';

        // Find active borrowing by current user for this book
        final activeBorrowIndex = state.borrowings.indexWhere((b) =>
            b.bookId == widget.bookId &&
            b.borrowerId == currentUserId &&
            b.status != BorrowStatus.completed &&
            b.status != BorrowStatus.cancelled);

        final activeBorrow =
            activeBorrowIndex != -1 ? state.borrowings[activeBorrowIndex] : null;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  Center(
                    child: Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: RuangBukuRadius.borderRadiusLg,
                        image: DecorationImage(
                          image: NetworkImage(book.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: RuangBukuElevation.level2,
                      ),
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xl),

                  // Title & Author
                  Text(
                    book.title,
                    style: textTheme.displayMedium,
                  ),
                  const SizedBox(height: RuangBukuSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        book.author,
                        style: textTheme.titleMedium?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                      Text(
                        l10n?.ownerLabelName(book.ownerName) ?? 'Owner: ${book.ownerName}',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RuangBukuSpacing.lg),

                  // Ratings & Details
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: RuangBukuSpacing.xs),
                      Text(
                        '4.5',
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(width: RuangBukuSpacing.md),
                      Text(
                        l10n?.reviewsCount('128') ?? '(128 Reviews)',
                        style: textTheme.bodyMedium?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          borderRadius: RuangBukuRadius.borderRadiusMd,
                        ),
                        child: Text(
                          l10n?.copyCondition(book.condition) ?? 'Copy: ${book.condition}',
                          style: textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Synopsis
                  Text(l10n?.synopsis ?? 'Synopsis', style: textTheme.headlineSmall),
                  const SizedBox(height: RuangBukuSpacing.md),
                  Text(
                    book.description,
                    style: textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: RuangBukuColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomActionBar(
                child:
                    BorrowActionSection(book: book, borrowing: activeBorrow),
              ),
            ),
          ],
        );
      },
    );
  }
}
