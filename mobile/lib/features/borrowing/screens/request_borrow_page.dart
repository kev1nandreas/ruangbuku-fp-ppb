import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class RequestBorrowPage extends StatelessWidget {
  const RequestBorrowPage({super.key});

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
          'Request to Borrow',
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
            // Book Summary Card
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
              padding: const EdgeInsets.all(RuangBukuSpacing.lg),
              child: Row(
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
            ),
            const SizedBox(height: RuangBukuSpacing.xl),

            // Lender Info
            Text('Lender', style: textTheme.headlineSmall),
            const SizedBox(height: RuangBukuSpacing.md),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://picsum.photos/seed/lender1/100/100'),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Text('Sarah M.', style: textTheme.titleMedium),
                const SizedBox(width: RuangBukuSpacing.sm),
                const Icon(Icons.verified, color: RuangBukuColors.primary, size: 16),
              ],
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Form Fields
            Text('Borrow Details', style: textTheme.headlineSmall),
            const SizedBox(height: RuangBukuSpacing.md),
            
            const TextField(
              decoration: InputDecoration(
                labelText: 'Pickup Date',
                hintText: 'Select date',
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            
            const TextField(
              decoration: InputDecoration(
                labelText: 'Return Date',
                hintText: 'Select date',
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),

            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message to Lender (Optional)',
                hintText: 'Hi, I would love to borrow this book...',
                alignLabelWithHint: true,
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
            // Mock send request
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request sent successfully!')),
            );
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Send Request'),
        ),
      ),
    );
  }
}

