import 'package:flutter/material.dart';
import '../theme.dart';

/// Small colored pill used to convey a status (Available, On Loan, Pending…).
///
/// [color] is the foreground/text color; the background defaults to that color
/// at 20% opacity unless [backgroundColor] is supplied.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.padding =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.fontWeight = FontWeight.w600,
  });

  final String label;
  final Color color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.2),
        borderRadius: RuangBukuRadius.borderRadiusSm,
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
