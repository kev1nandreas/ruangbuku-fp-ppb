import 'package:flutter/material.dart';
import '../theme.dart';

/// Compact horizontal book summary: small cover thumbnail + title + author.
class BookSummaryRow extends StatelessWidget {
  const BookSummaryRow({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  final String title;
  final String author;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 60,
          height: 90,
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
              Text(
                title,
                style: textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: RuangBukuSpacing.xs),
              Text(
                author,
                style: textTheme.bodyMedium?.copyWith(
                  color: RuangBukuColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
