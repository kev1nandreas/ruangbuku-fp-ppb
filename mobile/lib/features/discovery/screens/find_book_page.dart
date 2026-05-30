import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class FindBookPage extends StatelessWidget {
  const FindBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text(
          'RuangBuku',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: RuangBukuSpacing.lg),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage('https://picsum.photos/100/100'),
              backgroundColor: RuangBukuColors.surfaceContainerHigh,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filters Section
          Padding(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune), // Filter icon
                    hintText: 'Search books or neighbors...',
                    fillColor: RuangBukuColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: RuangBukuRadius.borderRadiusFull,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: RuangBukuRadius.borderRadiusFull,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: RuangBukuRadius.borderRadiusFull,
                      borderSide: const BorderSide(
                        color: RuangBukuColors.primary,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: RuangBukuSpacing.xl,
                      vertical: RuangBukuSpacing.lg,
                    ),
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(context, 'All Categories', isSelected: true),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      _buildFilterChip(context, 'Available Now', isSelected: false),
                      const SizedBox(width: RuangBukuSpacing.sm),
                      _buildFilterChip(context, 'Within 5km', isSelected: false),
                    ],
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('124 Books Found', style: textTheme.headlineSmall),
                    Row(
                      children: [
                        Text('Sort by Distance', style: textTheme.labelLarge),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: RuangBukuSpacing.lg,
                mainAxisSpacing: RuangBukuSpacing.lg,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildBookGridCard(
                  context,
                  title: ['The Midnight Library', '1984', 'Atomic Habits', 'Thinking, Fast and Slow'][index],
                  author: ['Matt Haig', 'George Orwell', 'James Clear', 'Daniel Kahneman'][index],
                  distance: ['1.2 km away', '2.5 km away', '3.1 km away', '4.8 km away'][index],
                  status: ['Available', 'On Loan', 'Available', 'Available'][index],
                  imageUrl: 'https://picsum.photos/seed/grid$index/200/300',
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            Icon(Icons.category_outlined, size: 16, color: RuangBukuColors.onPrimary),
            const SizedBox(width: RuangBukuSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected ? RuangBukuColors.onPrimary : RuangBukuColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookGridCard(BuildContext context, {
    required String title,
    required String author,
    required String distance,
    required String status,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final semanticColors = theme.extension<RuangBukuSemanticColors>()!;
    
    final isAvailable = status == 'Available';

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Status Badge
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: RuangBukuSpacing.sm,
                  right: RuangBukuSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable ? semanticColors.success.withValues(alpha: 0.9) : RuangBukuColors.surfaceContainerHigh.withValues(alpha: 0.9),
                      borderRadius: RuangBukuRadius.borderRadiusSm,
                    ),
                    child: Text(
                      status,
                      style: textTheme.labelSmall?.copyWith(
                        color: isAvailable ? RuangBukuColors.textDeep : RuangBukuColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(RuangBukuSpacing.md),
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
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: RuangBukuSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: RuangBukuColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: textTheme.bodySmall?.copyWith(
                        color: RuangBukuColors.textSecondary,
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

