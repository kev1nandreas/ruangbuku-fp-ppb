import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

class EditBookPage extends StatefulWidget {
  final String bookId;

  const EditBookPage({super.key, required this.bookId});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late String _condition;
  late bool _isAvailableForLending;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final book = state.books.firstWhere(
          (b) => b.id == widget.bookId,
          orElse: () => BookModel(
            id: '',
            isbn: '',
            title: 'Not Found',
            author: '',
            description: '',
            isPublic: false,
            statusVerifikasi: BookStatus.private,
            ownerId: '',
            ownerName: '',
            imageUrl: 'https://picsum.photos/200/300',
            distance: '',
            condition: 'Good',
          ),
        );

        if (!_isInitialized) {
          _condition = book.condition;
          _isAvailableForLending = book.isPublic && book.statusVerifikasi != BookStatus.private;
          _isInitialized = true;
        }

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
                        image: DecorationImage(
                          image: NetworkImage(book.imageUrl),
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
                            book.title,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: RuangBukuSpacing.xs),
                          Text(
                            book.author,
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
                  value: _condition,
                  items: const [
                    DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                    DropdownMenuItem(value: 'Very Good', child: Text('Very Good')),
                    DropdownMenuItem(value: 'Good', child: Text('Good')),
                    DropdownMenuItem(value: 'Acceptable', child: Text('Acceptable')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _condition = value;
                      });
                    }
                  },
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
                        value: _isAvailableForLending,
                        onChanged: (value) {
                          setState(() {
                            _isAvailableForLending = value;
                          });
                        },
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
                state.updateBookCondition(book.id, _condition, _isAvailableForLending);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved successfully')),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ),
        );
      },
    );
  }
}
