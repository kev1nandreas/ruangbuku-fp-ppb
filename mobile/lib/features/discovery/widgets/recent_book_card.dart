import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';
import '../../../l10n/app_localizations.dart';

/// Horizontal list card used in the "Recently Added" section.
class RecentBookCard extends StatelessWidget {
  const RecentBookCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.addedBy,
    required this.avatarUrl,
    required this.imageUrl,
    required this.isAvailable,
  });

  final String bookId;
  final String title;
  final String author;
  final String addedBy;
  final String avatarUrl;
  final String imageUrl;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;
    final l10n = AppLocalizations.of(context);

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowerBookDetailPage(bookId: bookId),
          ),
        );
      },
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
                    StatusBadge(
                      label: isAvailable ? (l10n?.available ?? 'Available') : (l10n?.onLoan ?? 'On Loan'),
                      color: isAvailable
                          ? semanticColors.success
                          : RuangBukuColors.textSecondary,
                      backgroundColor: (isAvailable
                              ? semanticColors.success
                              : semanticColors.neutralChip)
                          .withValues(alpha: 0.2),
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
                    Text(l10n?.addedBy(addedBy) ?? 'Added by $addedBy', style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
