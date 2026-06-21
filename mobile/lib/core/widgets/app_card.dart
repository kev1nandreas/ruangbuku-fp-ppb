import 'package:flutter/material.dart';
import '../theme.dart';

/// Standard surface card used across the app: white surface, rounded corners,
/// subtle border and (optionally) a level-1 shadow. Wrap with [onTap] to make
/// the whole card tappable.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(RuangBukuSpacing.md),
    this.onTap,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        boxShadow: elevated ? RuangBukuElevation.level1 : RuangBukuElevation.level0,
        border: Border.all(
          color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}
