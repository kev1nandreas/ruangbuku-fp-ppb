import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/borrow_action_section.dart';

class BorrowerBookDetailPage extends StatelessWidget {
  final String bookId;

  const BorrowerBookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        
        final book = state.books.firstWhere(
          (b) => b.id == bookId,
          orElse: () => BookModel(
            id: '',
            isbn: '',
            title: 'Not Found',
            author: 'Unknown',
            description: '',
            isPublic: false,
            statusVerifikasi: BookStatus.private,
            ownerId: '',
            ownerName: 'N/A',
            imageUrl: 'https://picsum.photos/200/300',
            distance: '',
            condition: 'Good',
          ),
        );

        final currentUserId = AuthNotifier.instance.user?.id ?? '';
        
        // Find active borrowing by current user for this book
        final activeBorrowIndex = state.borrowings.indexWhere((b) => 
          b.bookId == bookId && 
          b.borrowerId == currentUserId &&
          b.status != BorrowStatus.completed && 
          b.status != BorrowStatus.cancelled
        );

        BorrowModel? activeBorrow;
        if (activeBorrowIndex != -1) {
          activeBorrow = state.borrowings[activeBorrowIndex];
        }

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
                      image: DecorationImage(
                        image: NetworkImage(book.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: RuangBukuElevation.level2,
                    ),
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xl),

                // Title & Author
                Text(
                  book.title,
                  style: textTheme.displayMedium,
                ),
                const SizedBox(height: RuangBukuSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.author,
                      style: textTheme.titleMedium?.copyWith(
                        color: RuangBukuColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Owner: ${book.ownerName}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RuangBukuSpacing.lg),

                // Ratings & Details
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
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: RuangBukuColors.surfaceContainerLow,
                        borderRadius: RuangBukuRadius.borderRadiusSm,
                      ),
                      child: Text(
                        'Copy: ${book.condition}',
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RuangBukuSpacing.xxl),

                // Synopsis
                Text('Synopsis', style: textTheme.headlineSmall),
                const SizedBox(height: RuangBukuSpacing.md),
                Text(
                  book.description,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: RuangBukuColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          bottomSheet: BottomActionBar(
            child: BorrowActionSection(book: book, borrowing: activeBorrow),
          ),
        );
      },
    );
  }
}
