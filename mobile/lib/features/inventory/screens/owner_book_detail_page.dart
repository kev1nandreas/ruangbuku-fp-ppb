import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../discovery/domain/book_notifier.dart';
import '../widgets/delete_book_dialog.dart';
import 'edit_book_page.dart';
import '../../../l10n/app_localizations.dart';

class OwnerBookDetailPage extends StatefulWidget {
  final String bookId;

  const OwnerBookDetailPage({super.key, required this.bookId});

  @override
  State<OwnerBookDetailPage> createState() => _OwnerBookDetailPageState();
}

class _OwnerBookDetailPageState extends State<OwnerBookDetailPage> {
  bool _isLoading = true;
  BookModel? _book;

  @override
  void initState() {
    super.initState();
    _fetchBookDetail();
  }

  Future<void> _fetchBookDetail() async {
    setState(() => _isLoading = true);
    try {
      var book = await BookNotifier.instance.fetchBookDetail(widget.bookId);
      if (book == null) {
        final localIndex = RuangBukuState.instance.books.indexWhere((b) => b.id == widget.bookId);
        if (localIndex != -1) {
          book = RuangBukuState.instance.books[localIndex];
        }
      }
      if (mounted) {
        setState(() {
          _book = book;
        });
      }
    } catch (e) {
      if (mounted) {
        final localIndex = RuangBukuState.instance.books.indexWhere((b) => b.id == widget.bookId);
        if (localIndex != -1) {
          setState(() {
            _book = RuangBukuState.instance.books[localIndex];
          });
        }
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.errorLoadingBookDetails(e.toString()) ?? 'Error loading book details: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n?.myBookDetails ?? 'My Book Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_book == null) {
      final localIndex = RuangBukuState.instance.books.indexWhere((b) => b.id == widget.bookId);
      if (localIndex != -1) {
        _book = RuangBukuState.instance.books[localIndex];
      } else {
        return Scaffold(
          appBar: AppBar(title: Text(l10n?.myBookDetails ?? 'My Book Details')),
          body: Center(child: Text(l10n?.bookNotFound ?? 'Book not found')),
        );
      }
    }

    final book = _book!;

    String statusText = l10n?.available ?? 'Available';
    Color badgeColor = RuangBukuColors.statusActiveText;
    if (book.statusVerifikasi == BookStatus.publicPending) {
      statusText = l10n?.pendingApproval ?? 'Pending Approval';
      badgeColor = RuangBukuColors.statusPendingText;
    } else if (book.statusVerifikasi == BookStatus.publicRejected) {
      statusText = l10n?.rejected ?? 'Rejected';
      badgeColor = RuangBukuColors.statusDangerText;
    } else if (book.statusVerifikasi == BookStatus.private) {
      statusText = l10n?.privateBook ?? 'Private Collection';
      badgeColor = RuangBukuColors.neutralChip;
    }

    // Check if there is an active borrowing for this book
    final activeBorrowing = RuangBukuState.instance.ownerBorrowings.where((b) =>
        b.bookId == book.id &&
        b.status != BorrowStatus.completed &&
        b.status != BorrowStatus.cancelled).firstOrNull;

    if (activeBorrowing != null) {
      if (activeBorrowing.status == BorrowStatus.bookReceived) {
        statusText = l10n?.onLoanText ?? 'Sedang Dipinjam';
        badgeColor = RuangBukuColors.primary;
      } else if (activeBorrowing.status == BorrowStatus.requested) {
        statusText = l10n?.requestedStatus ?? 'Requested';
        badgeColor = RuangBukuColors.statusPendingText;
      } else {
        statusText = 'Dalam Transaksi';
        badgeColor = RuangBukuColors.primary;
      }
    }

    // Editing and deleting are blocked while the book is tied up in a borrow.
    final locked = activeBorrowing != null || book.hasActiveBorrowing;

    void showLockedMessage(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n?.myBookDetails ?? 'My Book Details',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: locked ? theme.colorScheme.onSurface.withValues(alpha: 0.38) : null,
            ),
            onPressed: locked
                ? () => showLockedMessage(l10n?.bookCurrentlyOnLoan ??
                    'Buku sedang dipinjam, tidak dapat diedit')
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditBookPage(bookId: widget.bookId),
                      ),
                    ),
            tooltip: locked ? 'Buku sedang dipinjam' : 'Edit Buku',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            Text(book.title, style: textTheme.displayMedium),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              book.author,
              style: textTheme.titleMedium?.copyWith(color: RuangBukuColors.textSecondary),
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Status Card
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: RuangBukuRadius.borderRadiusLg,
                boxShadow: RuangBukuElevation.level1,
                border: Border.all(color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3), width: 1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 16),
                        Expanded(child: Text(l10n?.condition ?? 'Condition', style: textTheme.labelLarge)),
                        Text(book.condition, style: textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 16),
                        Expanded(child: Text(l10n?.lendingStatus ?? 'Lending Status', style: textTheme.labelLarge)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.2),
                            borderRadius: RuangBukuRadius.borderRadiusSm,
                          ),
                          child: Text(
                            statusText,
                            style: textTheme.labelMedium?.copyWith(color: badgeColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    title: Text(l10n?.borrowHistory ?? 'Borrow History', style: textTheme.labelLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Danger Zone
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: locked
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                    : RuangBukuColors.error,
                side: BorderSide(
                  color: locked
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                      : RuangBukuColors.error,
                  width: 1.5,
                ),
              ),
              onPressed: locked
                  ? () => showLockedMessage(l10n?.bookCurrentlyOnLoan ??
                      'Buku sedang dipinjam, tidak dapat dihapus')
                  : () async {
                      final confirm =
                          await showDeleteBookDialog(context, book.title);
                      if (confirm == true && context.mounted) {
                        RuangBukuState.instance.deleteBook(book.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(l10n?.bookRemoved ??
                                'Book removed from library')));
                        Navigator.pop(context);
                      }
                    },
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n?.removeBook ?? 'Remove Book from Library'),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
          ],
        ),
      ),
    );
  }
}
