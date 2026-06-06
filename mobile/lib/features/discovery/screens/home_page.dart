import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning, Alex', style: textTheme.displayMedium),
                  const SizedBox(height: RuangBukuSpacing.sm),
                  Text(
                    'Find your next read from your community library.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: RuangBukuColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xl),
                  
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
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
                ],
              ),
            ),
            
            const SizedBox(height: RuangBukuSpacing.xxl),

            // Popular Near You Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Near You', style: textTheme.headlineSmall),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: RuangBukuColors.accent,
                    ),
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(width: RuangBukuSpacing.lg),
                itemBuilder: (context, index) {
                  return _buildPopularBookCard(
                    context,
                    title: ['The Secret History', 'Tomorrow, and Tomo...', 'Dune'][index],
                    author: ['Donna Tartt', 'Gabrielle Zevin', 'Frank Herbert'][index],
                    imageUrl: 'https://picsum.photos/seed/pop$index/200/300',
                  );
                },
              ),
            ),

            const SizedBox(height: RuangBukuSpacing.xxl),

            // Recently Added List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              child: Text('Recently Added', style: textTheme.headlineSmall),
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: RuangBukuSpacing.md),
              itemBuilder: (context, index) {
                return _buildRecentBookCard(
                  context,
                  title: ['Atomic Habits', 'The Midnight Library', 'Project Hail Mary'][index],
                  author: ['James Clear', 'Matt Haig', 'Andy Weir'][index],
                  addedBy: ['Sarah M.', 'David T.', 'Emma W.'][index],
                  avatarUrl: 'https://picsum.photos/seed/user$index/100/100',
                  imageUrl: 'https://picsum.photos/seed/rec$index/150/200',
                  status: ['Available', 'On Loan', 'Available'][index],
                );
              },
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularBookCard(BuildContext context, {required String title, required String author, required String imageUrl}) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: RuangBukuRadius.borderRadiusBase,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: RuangBukuElevation.level1,
            ),
          ),
          const SizedBox(height: RuangBukuSpacing.sm),
          Text(
            title,
            style: textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            author,
            style: textTheme.bodyMedium?.copyWith(
              color: RuangBukuColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookCard(BuildContext context, {
    required String title,
    required String author,
    required String addedBy,
    required String avatarUrl,
    required String imageUrl,
    required String status,
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
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 100,
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
                    // Status Badge (requested by user)
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
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: RuangBukuColors.surfaceContainerHigh,
                    ),
                    const SizedBox(width: RuangBukuSpacing.sm),
                    Text(
                      'Added by $addedBy',
                      style: textTheme.bodySmall,
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

