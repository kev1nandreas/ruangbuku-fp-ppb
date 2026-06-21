import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

/// Shows the logout confirmation dialog. Resolves to `true` when the user
/// confirms they want to sign out.
Future<bool?> showLogoutDialog(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final l10n = AppLocalizations.of(context);

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: RuangBukuColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: RuangBukuRadius.borderRadiusXl,
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.all(RuangBukuSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(RuangBukuSpacing.lg),
              decoration: const BoxDecoration(
                color: RuangBukuColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: RuangBukuColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.lg),
            Text(
              l10n?.logoutTitle ?? 'Keluar dari Akun',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              l10n?.logoutDesc ?? 'Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun.',
              style: textTheme.bodyMedium?.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RuangBukuSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RuangBukuColors.textPrimary,
                      side: const BorderSide(
                        color: RuangBukuColors.outlineVariant,
                      ),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: RuangBukuRadius.borderRadiusLg,
                      ),
                    ),
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(l10n?.cancel ?? 'Batal'),
                  ),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: RuangBukuColors.error,
                      foregroundColor: RuangBukuColors.onError,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: RuangBukuRadius.borderRadiusLg,
                      ),
                    ),
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(l10n?.logout ?? 'Keluar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
