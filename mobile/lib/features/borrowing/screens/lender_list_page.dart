import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_filter_chip.dart';
import '../widgets/lender_tile.dart';
import 'request_borrow_page.dart';

class LenderListPage extends StatelessWidget {
  final String bookId;

  const LenderListPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const names = ['Sarah M.', 'David T.', 'Emma W.', 'Michael K.'];
    const distances = ['1.2 km away', '2.5 km away', '3.1 km away', '4.8 km away'];
    const conditions = ['Like New', 'Good', 'Very Good', 'Acceptable'];
    const ratings = ['4.8', '4.9', '4.5', '4.2'];

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
              children: const [
                AppFilterChip(label: 'Distance: Nearest', isSelected: true),
                SizedBox(width: RuangBukuSpacing.sm),
                AppFilterChip(label: 'Condition', isSelected: false),
                SizedBox(width: RuangBukuSpacing.sm),
                AppFilterChip(label: 'Rating 4.0+', isSelected: false),
              ],
            ),
          ),

          // List of lenders
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: RuangBukuSpacing.marginMobile),
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return LenderTile(
                  name: names[index],
                  distance: distances[index],
                  condition: conditions[index],
                  avatarUrl: 'https://picsum.photos/seed/lender$index/100/100',
                  rating: ratings[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestBorrowPage(bookId: bookId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
