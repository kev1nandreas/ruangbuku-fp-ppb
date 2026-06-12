import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../discovery/domain/book_notifier.dart';

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
      final book = await BookNotifier.instance.fetchBookDetail(widget.bookId);
      if (mounted) {
        setState(() {
          _book = book;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading book details: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Book Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Book Details')),
        body: const Center(child: Text('Book not found')),
      );
    }

    final book = _book!;

    String statusText = 'Available';
    Color badgeColor = semanticColors.success;
    if (book.statusVerifikasi == BookStatus.publicPending) {
      statusText = 'Pending Approval';
      badgeColor = Colors.orange;
    } else if (book.statusVerifikasi == BookStatus.publicRejected) {
      statusText = 'Rejected';
      badgeColor = Colors.red;
    } else if (book.statusVerifikasi == BookStatus.private) {
      statusText = 'Private Collection';
      badgeColor = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Book Details',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not supported by backend yet')));
            },
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
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: RuangBukuColors.textSecondary),
                    title: Text('Condition', style: textTheme.labelLarge),
                    trailing: Text(book.condition, style: textTheme.bodyLarge),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz, color: RuangBukuColors.textSecondary),
                    title: Text('Lending Status', style: textTheme.labelLarge),
                    trailing: Container(
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
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history, color: RuangBukuColors.textSecondary),
                    title: Text('Borrow History', style: textTheme.labelLarge),
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
                foregroundColor: RuangBukuColors.error,
                side: const BorderSide(color: RuangBukuColors.error, width: 1.5),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete feature not supported by backend yet')));
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove Book from Library'),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
          ],
        ),
      ),
    );
  }
}
