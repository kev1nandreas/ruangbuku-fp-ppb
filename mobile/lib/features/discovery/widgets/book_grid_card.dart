import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/status_badge.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';

/// Grid cell used on the Find Book results grid: cover with an overlaid status
/// badge plus title/author/distance below.
class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.distance,
    required this.imageUrl,
    required this.isAvailable,
  });

  final String bookId;
  final String title;
  final String author;
  final String distance;
  final String imageUrl;
  final bool isAvailable;

  Widget _coverFallback() {
    return const ColoredBox(
      color: RuangBukuColors.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.menu_book_outlined,
          size: 40,
          color: RuangBukuColors.textSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

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
            color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
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
                        ? _coverFallback()
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                _coverFallback(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const ColoredBox(
                                color: RuangBukuColors.surfaceContainerHigh,
                                child: Center(
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
                      label: isAvailable ? 'Available' : 'On Loan',
                      color: isAvailable
                          ? RuangBukuColors.textDeep
                          : RuangBukuColors.textSecondary,
                      backgroundColor: (isAvailable
                              ? semanticColors.success
                              : RuangBukuColors.surfaceContainerHigh)
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
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: RuangBukuColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: textTheme.bodySmall?.copyWith(
                          color: RuangBukuColors.textSecondary,
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
