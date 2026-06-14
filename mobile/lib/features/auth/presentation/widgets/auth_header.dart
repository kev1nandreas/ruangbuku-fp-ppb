import 'package:flutter/material.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';

/// Branded header for the auth screens: app icon, name and tagline.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n?.ruangBuku ?? 'RuangBuku',
          style: RuangBukuTypography.displayLargeMobile.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: RuangBukuSpacing.sm),
        Text(
          l10n?.authHeaderTagline ?? 'Berbagi buku, memperluas wawasan.',
          style: RuangBukuTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
