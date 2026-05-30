import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'request_borrow_page.dart';

class LenderListPage extends StatelessWidget {
  const LenderListPage({super.key});

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
          'Select Lender',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            child: Row(
              children: [
                _buildFilterChip(context, 'Distance: Nearest', isSelected: true),
                const SizedBox(width: RuangBukuSpacing.sm),
                _buildFilterChip(context, 'Condition', isSelected: false),
                const SizedBox(width: RuangBukuSpacing.sm),
                _buildFilterChip(context, 'Rating 4.0+', isSelected: false),
              ],
            ),
          ),
          
          // List of lenders
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildLenderTile(
                  context,
                  name: ['Sarah M.', 'David T.', 'Emma W.', 'Michael K.'][index],
                  distance: ['1.2 km away', '2.5 km away', '3.1 km away', '4.8 km away'][index],
                  condition: ['Like New', 'Good', 'Very Good', 'Acceptable'][index],
                  avatarUrl: 'https://picsum.photos/seed/lender$index/100/100',
                  rating: ['4.8', '4.9', '4.5', '4.2'][index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, {required bool isSelected}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.lg, vertical: RuangBukuSpacing.sm),
      decoration: BoxDecoration(
        color: isSelected ? RuangBukuColors.primary : RuangBukuColors.surfaceContainerLow,
        borderRadius: RuangBukuRadius.borderRadiusFull,
        border: Border.all(
          color: isSelected ? RuangBukuColors.primary : RuangBukuColors.outlineVariant,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: isSelected ? RuangBukuColors.onPrimary : RuangBukuColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLenderTile(BuildContext context, {
    required String name,
    required String distance,
    required String condition,
    required String avatarUrl,
    required String rating,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RequestBorrowPage(),
          ),
        );
      },
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
                      const Text('•', style: TextStyle(color: RuangBukuColors.outline)),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      const Icon(Icons.location_on_outlined, size: 14, color: RuangBukuColors.textSecondary),
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
                Text(
                  'Condition',
                  style: textTheme.labelSmall,
                ),
                Text(
                  condition,
                  style: textTheme.labelMedium?.copyWith(
                    color: RuangBukuColors.primary,
                  ),
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

