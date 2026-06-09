import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../auth/data/models/user_model.dart';

/// Profile header: avatar, name, email, and a read-only role chip. Shows a
/// spinner while the profile is loading for the first time.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.isLoading,
  });

  final UserModel? user;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (user == null && isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: RuangBukuSpacing.xxl),
        child: CircularProgressIndicator(color: RuangBukuColors.primary),
      );
    }

    final name = user?.name ?? '—';
    final email = user?.email ?? '—';
    final roleName = user?.primaryRoleName;
    final avatarSeed = user?.id ?? 'guest';

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/$avatarSeed/100/100',
            ),
          ),
          const SizedBox(height: RuangBukuSpacing.lg),
          Text(name, style: textTheme.headlineSmall),
          const SizedBox(height: RuangBukuSpacing.xs),
          Text(
            email,
            style: textTheme.bodyMedium
                ?.copyWith(color: RuangBukuColors.textSecondary),
          ),
          if (roleName != null) ...[
            const SizedBox(height: RuangBukuSpacing.md),
            _RoleChip(roleName: roleName),
          ],
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.roleName});

  final String roleName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.lg,
        vertical: RuangBukuSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: RuangBukuColors.primary.withValues(alpha: 0.12),
        borderRadius: RuangBukuRadius.borderRadiusFull,
        border: Border.all(
          color: RuangBukuColors.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_user_outlined,
              size: 16, color: RuangBukuColors.primary),
          const SizedBox(width: RuangBukuSpacing.xs),
          Text(
            roleName.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: RuangBukuColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}
