import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../borrowing/data/models/borrow_model.dart';
import '../../borrowing/screens/borrowing_detail_page.dart';
import '../../borrowing/widgets/borrow_status_chip.dart';

/// Compact tappable row for one borrow transaction, opening its detail page.
/// Used for both the borrower view and the lender (owner) view of a borrow.
class BorrowingTransactionCard extends StatelessWidget {
  final BorrowModel borrowing;
  final bool isLender;

  const BorrowingTransactionCard({
    super.key,
    required this.borrowing,
    required this.isLender,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BorrowingDetailPage(borrowingId: borrowing.id),
        ),
      ),
      borderRadius: RuangBukuRadius.borderRadiusLg,
      child: Container(
        padding: const EdgeInsets.all(RuangBukuSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: RuangBukuRadius.borderRadiusLg,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: RuangBukuRadius.borderRadiusSm,
              child: Image.network(
                borrowing.bookImageUrl,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: RuangBukuSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    borrowing.bookTitle,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLender
                        ? (l10n?.borrowerName(borrowing.borrowerName) ??
                            'Peminjam: ${borrowing.borrowerName}')
                        : 'Pemilik Buku',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  BorrowStatusChip(status: borrowing.status),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
