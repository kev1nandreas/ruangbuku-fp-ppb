import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/book_summary_row.dart';
import '../../../core/widgets/bottom_action_bar.dart';
import '../widgets/condition_dropdown.dart';
import '../widgets/lending_permission_switch.dart';

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
                BookSummaryRow(
                  title: book.title,
                  author: book.author,
                  imageUrl: book.imageUrl,
                ),
                const SizedBox(height: RuangBukuSpacing.xxl),

                Text(
                  'Update Your Copy',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: RuangBukuSpacing.md),
                ConditionDropdown(
                  value: _condition,
                  onChanged: (value) => setState(() => _condition = value),
                ),
                const SizedBox(height: RuangBukuSpacing.lg),

                LendingPermissionSwitch(
                  value: _isAvailableForLending,
                  onChanged: (value) =>
                      setState(() => _isAvailableForLending = value),
                ),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          bottomSheet: BottomActionBar(
            child: FilledButton(
              onPressed: () {
                state.updateBookCondition(
                    book.id, _condition, _isAvailableForLending);
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
