import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

/// Shows the book-return inspection dialog where the borrower/lender marks the
/// book as returned in good or damaged condition.
Future<void> showReturnInspectionDialog(
  BuildContext context,
  BorrowModel borrowing,
) {
  final damageController = TextEditingController();
  final state = RuangBukuState.instance;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Book Return Inspection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please inspect the returned book. Is the book returned in good condition (A) or is it damaged/cacat (B)?',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: damageController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Damage Details (Only if Damaged)',
                hintText: 'e.g., Cover ripped, pages missing...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: RuangBukuColors.error,
              side: const BorderSide(color: RuangBukuColors.error),
            ),
            onPressed: () {
              final desc = damageController.text.trim();
              state.returnBook(
                borrowing.id,
                isGoodCondition: false,
                damageDescription:
                    desc.isEmpty ? 'Halaman terlipat/sobek' : desc,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Book marked as DAMAGED. Dispute sent to Admin (F-03).')),
              );
            },
            child: const Text('Damaged (B)'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: RuangBukuColors.primary,
            ),
            onPressed: () {
              state.returnBook(borrowing.id, isGoodCondition: true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Book returned in GOOD condition. Refund pending (F-03).')),
              );
            },
            child: const Text('Good (A)'),
          ),
        ],
      );
    },
  );
}
