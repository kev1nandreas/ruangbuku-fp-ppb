import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

/// Type-to-confirm delete dialog. The Delete button enables only once the user
/// types the exact [bookTitle]. Resolves to `true` when confirmed.
Future<bool?> showDeleteBookDialog(BuildContext context, String bookTitle) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final controller = TextEditingController();
      final l10n = AppLocalizations.of(context);
      return AlertDialog(
        title: Text(
            l10n?.deleteConfirmTitle ?? 'Do you want to delete your book?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n?.deleteConfirmMsg(bookTitle) ??
                'Please enter "$bookTitle" to confirm.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: bookTitle,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final isMatch = value.text == bookTitle;
              return FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isMatch ? RuangBukuColors.error : RuangBukuColors.outlineVariant,
                ),
                onPressed:
                    isMatch ? () => Navigator.pop(context, true) : null,
                child: Text(l10n?.delete ?? 'Delete'),
              );
            },
          ),
        ],
      );
    },
  );
}
