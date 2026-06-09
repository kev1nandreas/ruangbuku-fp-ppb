import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

/// Branded header for the auth screens: app icon, name and tagline.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: RuangBukuColors.primary,
            borderRadius: RuangBukuRadius.borderRadiusXl,
            boxShadow: RuangBukuElevation.level2,
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: RuangBukuColors.onPrimary,
            size: 40,
          ),
        ),
        const SizedBox(height: RuangBukuSpacing.lg),
        Text(
          'RuangBuku',
          style: RuangBukuTypography.displayLargeMobile.copyWith(
            color: RuangBukuColors.textDeep,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: RuangBukuSpacing.sm),
        Text(
          'Berbagi buku, memperluas wawasan.',
          style: RuangBukuTypography.bodyMedium.copyWith(
            color: RuangBukuColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
