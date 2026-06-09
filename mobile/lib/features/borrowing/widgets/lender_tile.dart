import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// List tile representing a lender offering a book, with rating, distance and
/// copy condition.
class LenderTile extends StatelessWidget {
  const LenderTile({
    super.key,
    required this.name,
    required this.distance,
    required this.condition,
    required this.avatarUrl,
    required this.rating,
    this.onTap,
  });

  final String name;
  final String distance;
  final String condition;
  final String avatarUrl;
  final String rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: RuangBukuColors.surfaceContainerHigh,
            ),
            const SizedBox(width: RuangBukuSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: textTheme.titleMedium),
                  const SizedBox(height: RuangBukuSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: textTheme.bodySmall),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      const Text('•',
                          style: TextStyle(color: RuangBukuColors.outline)),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: RuangBukuColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(distance, style: textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Condition', style: textTheme.labelSmall),
                Text(
                  condition,
                  style: textTheme.labelMedium
                      ?.copyWith(color: RuangBukuColors.primary),
                ),
              ],
            ),
            const SizedBox(width: RuangBukuSpacing.sm),
            const Icon(Icons.chevron_right, color: RuangBukuColors.outline),
          ],
        ),
      ),
    );
  }
}
