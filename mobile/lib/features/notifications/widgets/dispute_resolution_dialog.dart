import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

/// Admin dialog to resolve a damage dispute by setting a deduction amount and a
/// decision note, then refunding the remaining deposit.
Future<void> showDisputeResolutionDialog(
  BuildContext context,
  BorrowModel borrowing,
) {
  final fineController = TextEditingController(text: '15000');
  final noteController =
      TextEditingController(text: 'Biaya perbaikan halaman robek');
  final state = RuangBukuState.instance;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Resolve Damage Dispute'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book: ${borrowing.bookTitle}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Borrower: ${borrowing.borrowerName}'),
            Text(
                'Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}'),
            const SizedBox(height: RuangBukuSpacing.lg),
            TextField(
              controller: fineController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Deduction Amount (Rp)',
                hintText: 'e.g., 15000',
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Decision / Note',
                hintText: 'Biaya ganti cover / halaman robek',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: RuangBukuColors.primary),
            onPressed: () {
              final fine = double.tryParse(fineController.text.trim()) ?? 0.0;
              final note = noteController.text.trim();
              state.resolveRefundOrDispute(borrowing.id,
                  deduction: fine, note: note);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Dispute resolved. Deposit refunded after deduction.')),
              );
            },
            child: const Text('Confirm Resolution'),
          ),
        ],
      );
    },
  );
}
