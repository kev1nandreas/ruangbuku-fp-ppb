import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../data/models/borrow_model.dart';
import '../data/models/borrow_status_x.dart';

/// Small colored pill showing a borrow's localized status. Reused by the
/// borrowing detail, the borrowing list, and the admin transaction list so the
/// chip styling lives in one place.
class BorrowStatusChip extends StatelessWidget {
  final BorrowStatus status;

  const BorrowStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.chipBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label(l10n),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: status.labelColor(context),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
