import 'package:flutter/material.dart';
import '../theme.dart';

/// Bottom-anchored action container with a soft top shadow. Used as the
/// `bottomSheet` of detail/form screens to hold the primary action(s).
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: RuangBukuColors.shadowTint.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }
}
