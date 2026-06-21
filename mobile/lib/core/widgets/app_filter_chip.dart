import 'package:flutter/material.dart';
import '../theme.dart';

/// Pill-shaped selectable filter chip. Set [onTap] to make it interactive.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.showCheckWhenSelected = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  /// When true, a check icon is shown to the left of the label while selected.
  final bool showCheckWhenSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.lg,
        vertical: RuangBukuSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? RuangBukuColors.primary
            : Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: RuangBukuRadius.borderRadiusFull,
        border: Border.all(
          color: isSelected
              ? RuangBukuColors.primary
              : RuangBukuColors.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected && showCheckWhenSelected) ...[
            const Icon(Icons.check, size: 16, color: RuangBukuColors.onPrimary),
            const SizedBox(width: RuangBukuSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? RuangBukuColors.onPrimary
                  : RuangBukuColors.textPrimary,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
