import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

/// Toggle row letting the owner mark a book as available for lending. Shared by
/// the add/edit book forms.
class LendingPermissionSwitch extends StatelessWidget {
  const LendingPermissionSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
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
                Text(AppLocalizations.of(context)?.availableLending ?? 'Available for Lending', style: textTheme.titleMedium),
                const SizedBox(height: RuangBukuSpacing.xs),
                Text(
                  AppLocalizations.of(context)?.availableLendingDesc ?? 'Allow others in your area to borrow this book.',
                  style: textTheme.bodySmall
                      ?.copyWith(color: RuangBukuColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
