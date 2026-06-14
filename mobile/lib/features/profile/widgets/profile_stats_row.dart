import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

/// The three-up stat row (Books Owned / Borrowed / Lent) on the profile page.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.ownedCount,
    required this.borrowedCount,
    required this.lentCount,
    this.onNavigateToTab,
  });

  final int ownedCount;
  final int borrowedCount;
  final int lentCount;
  final void Function(int)? onNavigateToTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        boxShadow: RuangBukuElevation.level1,
        border: Border.all(
          color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _stat(
            context,
            '$ownedCount',
            l10n?.owned ?? 'Books Owned',
            onTap: () => onNavigateToTab?.call(2),
          ),
          _divider(),
          _stat(
            context,
            '$borrowedCount',
            l10n?.borrowed ?? 'Borrowed',
            onTap: () => onNavigateToTab?.call(3),
          ),
          _divider(),
          _stat(
            context,
            '$lentCount',
            l10n?.lent ?? 'Lent',
            onTap: () => onNavigateToTab?.call(3),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: RuangBukuColors.divider);

  Widget _stat(BuildContext context, String value, String label, {VoidCallback? onTap}) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: RuangBukuRadius.borderRadiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.md, vertical: RuangBukuSpacing.xs),
        child: Column(
          children: [
            Text(value,
                style: textTheme.headlineSmall
                    ?.copyWith(color: RuangBukuColors.primary)),
            const SizedBox(height: RuangBukuSpacing.xs),
            Text(label, style: textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
