import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../borrowing/screens/borrower_book_detail_page.dart';

/// Tall book cover card used in the horizontal "Popular Near You" carousel.
class PopularBookCard extends StatelessWidget {
  const PopularBookCard({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  final String bookId;
  final String title;
  final String author;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BorrowerBookDetailPage(bookId: bookId),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: RuangBukuRadius.borderRadiusBase,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: RuangBukuElevation.level1,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              title,
              style: textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              author,
              style: textTheme.bodyMedium?.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
