import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

/// Admin dialog to settle a damage dispute (resolve-damage route).
/// The admin reviews the reported damage and decides whether the deposit goes
/// back to the borrower or to the owner as compensation.
Future<void> showDisputeResolutionDialog(
  BuildContext context,
  BorrowModel borrowing,
) async {
  final noteController =
      TextEditingController(text: 'Biaya perbaikan halaman robek');
  final state = RuangBukuState.instance;
  bool depositToOwner = true;

  try {
    await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Resolve Damage Dispute'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Book: ${borrowing.bookTitle}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Borrower: ${borrowing.borrowerName}'),
                  Text(
                      'Reported Damage: ${borrowing.damageReport?.description ?? "N/A"}'),
                  const SizedBox(height: RuangBukuSpacing.lg),
                  const Text('Send deposit to:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  RadioGroup<bool>(
                    groupValue: depositToOwner,
                    onChanged: (v) => setState(() => depositToOwner = v ?? true),
                    child: const Column(
                      children: [
                        RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: true,
                          title: Text('Owner (book damaged)'),
                        ),
                        RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          value: false,
                          title: Text('Borrower (damage waived)'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.md),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'Decision / Note (required)',
                      hintText: 'Biaya ganti cover / halaman robek',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: RuangBukuColors.primary),
                onPressed: () async {
                  final note = noteController.text.trim();
                  if (note.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Catatan keputusan wajib diisi.')),
                    );
                    return;
                  }
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await state.resolveDamage(
                      borrowing.id,
                      toOwner: depositToOwner,
                      note: note,
                    );
                    navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(
                          content: Text(
                              'Dispute resolved. Deposit sent to ${depositToOwner ? "owner" : "borrower"}.')),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Gagal menyelesaikan: $e')),
                    );
                  }
                },
                child: const Text('Confirm Resolution'),
              ),
            ],
          );
          },
        );
      },
    );
  } finally {
    noteController.dispose();
  }
}
