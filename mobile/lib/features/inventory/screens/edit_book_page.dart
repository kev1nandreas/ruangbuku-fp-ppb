import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class EditBookPage extends StatelessWidget {
  const EditBookPage({super.key});

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
          'Edit Book Details',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Summary
            Row(
              children: [
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: RuangBukuRadius.borderRadiusBase,
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/id/1015/200/300'),
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
                        'The Midnight Library',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: RuangBukuSpacing.xs),
                      Text(
                        'Matt Haig',
                        style: textTheme.bodyMedium?.copyWith(
                          color: RuangBukuColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            Text(
              'Update Your Copy',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Condition',
              ),
              initialValue: 'Like New',
              items: const [
                DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                DropdownMenuItem(value: 'Very Good', child: Text('Very Good')),
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Acceptable', child: Text('Acceptable')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            
            // Lending Permission
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: RuangBukuRadius.borderRadiusLg,
                border: Border.all(
                  color: RuangBukuColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              padding: const EdgeInsets.all(RuangBukuSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available for Lending', style: textTheme.titleMedium),
                        const SizedBox(height: RuangBukuSpacing.xs),
                        Text(
                          'Allow others in your area to borrow this book.',
                          style: textTheme.bodySmall?.copyWith(color: RuangBukuColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changes saved successfully')),
            );
            Navigator.pop(context);
          },
          child: const Text('Save Changes'),
        ),
      ),
    );
  }
}

