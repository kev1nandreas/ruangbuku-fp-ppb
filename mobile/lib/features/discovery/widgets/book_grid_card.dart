import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/status_badge.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';
import '../../../l10n/app_localizations.dart';

/// Grid cell used on the Find Book results grid: cover with an overlaid status
/// badge plus title/author below.
class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.isAvailable,
    required this.genre,
  });

  final String bookId;
  final String title;
  final String author;
  final String imageUrl;
  final bool isAvailable;
  final String genre;

  Widget _coverFallback(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.menu_book_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;
    final l10n = AppLocalizations.of(context);

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
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: (imageUrl.isEmpty)
                        ? _coverFallback(context)
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                _coverFallback(context),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return ColoredBox(
                                color: theme.colorScheme.surfaceContainerHigh,
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Positioned(
                    top: RuangBukuSpacing.sm,
                    right: RuangBukuSpacing.sm,
                    child: StatusBadge(
                      label: isAvailable ? (l10n?.available ?? 'Available') : (l10n?.onLoan ?? 'On Loan'),
                      color: isAvailable
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      backgroundColor: (isAvailable
                              ? semanticColors.success
                              : theme.colorScheme.surfaceContainerHigh)
                          .withValues(alpha: 0.9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
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
                      Icon(Icons.category_outlined,
                          size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          genre,
                          style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
