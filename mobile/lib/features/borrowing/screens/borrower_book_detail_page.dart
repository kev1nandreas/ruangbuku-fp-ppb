import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'lender_list_page.dart';

class BorrowerBookDetailPage extends StatelessWidget {
  const BorrowerBookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Details',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Center(
              child: Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: RuangBukuRadius.borderRadiusLg,
                  image: const DecorationImage(
                    image: NetworkImage('https://picsum.photos/id/1015/300/450'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: RuangBukuElevation.level2,
                ),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            // Title & Author
            Text(
              'The Midnight Library',
              style: textTheme.displayMedium,
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              'Matt Haig',
              style: textTheme.titleMedium?.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),

            // Ratings
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: RuangBukuSpacing.xs),
                Text(
                  '4.5',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Text(
                  '(128 Reviews)',
                  style: textTheme.bodyMedium?.copyWith(
                    color: RuangBukuColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Synopsis
            Text('Synopsis', style: textTheme.headlineSmall),
            const SizedBox(height: RuangBukuSpacing.md),
            Text(
              'Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived. To see how things would be if you had made other choices... Would you have done anything different, if you had the chance to undo your regrets?',
              style: textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: RuangBukuColors.textSecondary,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              'Read more',
              style: textTheme.labelLarge?.copyWith(
                color: RuangBukuColors.primary,
              ),
            ),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: RuangBukuColors.shadowTint.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LenderListPage(),
              ),
            );
          },
          child: const Text('Borrow Book'),
        ),
      ),
    );
  }
}

