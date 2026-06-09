import 'package:flutter/material.dart';
import '../theme.dart';

/// Centered empty-state placeholder: icon + title + supporting message.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: RuangBukuColors.primary),
            const SizedBox(height: RuangBukuSpacing.lg),
            Text(title, style: textTheme.titleLarge),
            const SizedBox(height: RuangBukuSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: RuangBukuColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
