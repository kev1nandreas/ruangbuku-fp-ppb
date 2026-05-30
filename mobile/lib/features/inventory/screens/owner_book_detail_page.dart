import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'edit_book_page.dart';

class OwnerBookDetailPage extends StatelessWidget {
  const OwnerBookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Book Details',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditBookPage(),
                ),
              );
            },
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
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Status Card
            Container(
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
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: RuangBukuColors.textSecondary),
                    title: Text('Condition', style: textTheme.labelLarge),
                    trailing: Text('Like New', style: textTheme.bodyLarge),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz, color: RuangBukuColors.textSecondary),
                    title: Text('Lending Status', style: textTheme.labelLarge),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: semanticColors.success.withValues(alpha: 0.2),
                        borderRadius: RuangBukuRadius.borderRadiusSm,
                      ),
                      child: Text(
                        'Available',
                        style: textTheme.labelMedium?.copyWith(
                          color: semanticColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history, color: RuangBukuColors.textSecondary),
                    title: Text('Borrow History', style: textTheme.labelLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Danger Zone
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: RuangBukuColors.error,
                side: const BorderSide(color: RuangBukuColors.error, width: 1.5),
              ),
              onPressed: () {},
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove Book from Library'),
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
          ],
        ),
      ),
    );
  }
}

