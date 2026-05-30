import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'add_book_page.dart';
import 'edit_book_page.dart';
import 'owner_book_detail_page.dart';

class YourBooksPage extends StatelessWidget {
  const YourBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Books',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.lg),
        itemBuilder: (context, index) {
          return _buildOwnerBookCard(
            context,
            title: ['Sapiens', 'Dune', 'Project Hail Mary'][index],
            author: ['Yuval Noah Harari', 'Frank Herbert', 'Andy Weir'][index],
            status: ['Available', 'On Loan', 'Available'][index],
            imageUrl: 'https://picsum.photos/seed/own$index/150/200',
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOwnerBookCard(BuildContext context, {
    required String title,
    required String author,
    required String status,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

    final isAvailable = status == 'Available';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OwnerBookDetailPage(),
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
        padding: const EdgeInsets.all(RuangBukuSpacing.md),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAvailable ? semanticColors.success.withValues(alpha: 0.2) : semanticColors.neutralChip.withValues(alpha: 0.2),
                          borderRadius: RuangBukuRadius.borderRadiusSm,
                        ),
                        child: Text(
                          status,
                          style: textTheme.labelSmall?.copyWith(
                            color: isAvailable ? semanticColors.success : RuangBukuColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                          padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.md),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditBookPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: RuangBukuColors.error,
                          side: const BorderSide(color: RuangBukuColors.error, width: 1.5),
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.md),
                        ),
                        onPressed: () {
                          // Mock delete action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book deleted')),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
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

