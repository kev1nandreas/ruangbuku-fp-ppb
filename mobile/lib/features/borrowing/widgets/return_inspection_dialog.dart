import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

/// Shows the book-return inspection dialog where the borrower/lender marks the
/// book as returned in good or damaged condition.
Future<void> showReturnInspectionDialog(
  BuildContext context,
  BorrowModel borrowing,
) async {
  final damageController = TextEditingController();
  final state = RuangBukuState.instance;
  bool showDamageInput = false;

  try {
    await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Book Return Inspection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  showDamageInput
                      ? 'Harap tuliskan detail kerusakan buku di bawah ini:'
                      : 'Please inspect the returned book. Is the book returned in good condition (A) or is it damaged/cacat (B)?',
                  style: const TextStyle(height: 1.4),
                ),
                if (showDamageInput) ...[
                  const SizedBox(height: RuangBukuSpacing.lg),
                  TextField(
                    controller: damageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Damage Details',
                      hintText: 'e.g., Cover ripped, pages missing...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ],
            ),
            actionsPadding: const EdgeInsets.all(RuangBukuSpacing.lg),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!showDamageInput) ...[
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
                    const SizedBox(height: RuangBukuSpacing.sm),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: RuangBukuColors.error,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          showDamageInput = true;
                        });
                      },
                      child: const Text('Damaged (B)'),
                    ),
                  ] else ...[
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: RuangBukuColors.error,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final desc = damageController.text.trim();
                        if (desc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Harap isi detail kerusakan.')),
                          );
                          return;
                        }
                        state.returnBook(
                          borrowing.id,
                          isGoodCondition: false,
                          damageDescription: desc,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Book marked as DAMAGED. Dispute sent to Admin (F-03).')),
                        );
                      },
                      child: const Text('Submit Damage Report'),
                    ),
                  ],
                  const SizedBox(height: RuangBukuSpacing.sm),
                  TextButton(
                    onPressed: () {
                      if (showDamageInput) {
                        setState(() {
                          showDamageInput = false;
                          damageController.clear();
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(showDamageInput ? 'Back' : 'Cancel'),
                  ),
                ],
              ),
            ],
          );
          },
        );
      },
    );
  } finally {
    damageController.dispose();
  }
}
