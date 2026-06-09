import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// List tile used for profile menu entries (Edit Profile, Payment Details…).
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: RuangBukuColors.surfaceContainerLow,
          borderRadius: RuangBukuRadius.borderRadiusSm,
        ),
        child: Icon(icon, color: RuangBukuColors.textPrimary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing:
          const Icon(Icons.chevron_right, color: RuangBukuColors.textSecondary),
      onTap: onTap,
    );
  }
}
