import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../screens/edit_book_page.dart';
import '../screens/owner_book_detail_page.dart';
import '../../../l10n/app_localizations.dart';

/// Catalog card for a book the user owns, with Edit/Delete actions and a status
/// badge (Available / Pending / Rejected / Private / On Loan).
class OwnerBookCard extends StatelessWidget {
  const OwnerBookCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.status,
    required this.imageUrl,
  });

  final String bookId;
  final String title;
  final String author;
  final String status;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;
    final state = RuangBukuState.instance;
    final l10n = AppLocalizations.of(context);

    // Resolve status badge colors.
    Color textColor = RuangBukuColors.textSecondary;
    Color badgeBg = semanticColors.neutralChip.withValues(alpha: 0.2);
    switch (status) {
      case 'Available':
        textColor = semanticColors.success;
        badgeBg = semanticColors.success.withValues(alpha: 0.2);
        break;
      case 'Pending Approval':
        textColor = Colors.orange;
        badgeBg = Colors.orange.withValues(alpha: 0.2);
        break;
      case 'Rejected':
        textColor = Colors.red;
        badgeBg = Colors.red.withValues(alpha: 0.2);
        break;
    }

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerBookDetailPage(bookId: bookId),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 120,
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
                      label: status,
                      color: textColor,
                      backgroundColor: badgeBg,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                            horizontal: RuangBukuSpacing.md),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookPage(bookId: bookId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: Text(l10n?.edit ?? 'Edit'),
                    ),
                    const SizedBox(width: RuangBukuSpacing.sm),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: RuangBukuColors.error,
                        side: const BorderSide(
                            color: RuangBukuColors.error, width: 1.5),
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                            horizontal: RuangBukuSpacing.md),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: Text(l10n?.deleteConfirmTitle ?? 'Do you want to delete your book?'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n?.deleteConfirmMsg(title) ?? 'Please enter "$title" to confirm.'),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: title,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(l10n?.cancel ?? 'Cancel'),
                                  ),
                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: controller,
                                  builder: (context, value, child) {
                                    final isMatch = value.text == title;
                                    return FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: isMatch ? RuangBukuColors.error : Colors.grey,
                                      ),
                                      onPressed: isMatch ? () => Navigator.pop(context, true) : null,
                                      child: Text(l10n?.delete ?? 'Delete'),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true && context.mounted) {
                          state.deleteBook(bookId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(l10n?.bookRemoved ?? 'Book removed from library')),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: Text(l10n?.delete ?? 'Delete'),
                    ),
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
