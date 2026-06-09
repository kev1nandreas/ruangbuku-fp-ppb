import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';

/// Card shown on the admin curation dashboard with Approve/Reject actions for a
/// pending book submission.
class AdminCurationCard extends StatelessWidget {
  const AdminCurationCard({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = RuangBukuState.instance;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 105,
            decoration: BoxDecoration(
              borderRadius: RuangBukuRadius.borderRadiusBase,
              image: DecorationImage(
                image: NetworkImage(book.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: RuangBukuSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(book.author,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: RuangBukuColors.textSecondary)),
                const SizedBox(height: 4),
                Text('ISBN: ${book.isbn}', style: textTheme.labelSmall),
                Text('Owner: ${book.ownerName}', style: textTheme.bodySmall),
                const SizedBox(height: RuangBukuSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                          foregroundColor: RuangBukuColors.error,
                          side: const BorderSide(color: RuangBukuColors.error),
                        ),
                        onPressed: () => state.verifyBook(book.id, false),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: RuangBukuSpacing.md),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: EdgeInsets.zero,
                          backgroundColor: RuangBukuColors.primary,
                        ),
                        onPressed: () => state.verifyBook(book.id, true),
                        child: const Text('Approve'),
                      ),
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
