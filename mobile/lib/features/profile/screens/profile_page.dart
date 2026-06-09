import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../auth/data/models/user_model.dart';
import 'payment_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load the freshest profile (incl. roles) from /me on entry.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthNotifier.instance.fetchProfile().then((_) => _syncRoleToAppState());
    });
  }

  /// Mirrors the server role into the local app state so the rest of the UI
  /// (admin/lender/borrower views) reflects the authenticated user's role.
  void _syncRoleToAppState() {
    final roleName = AuthNotifier.instance.user?.primaryRoleName;
    final mapped = switch (roleName) {
      'admin' => UserRole.admin,
      'lender' => UserRole.lender,
      'borrower' => UserRole.borrower,
      _ => null,
    };
    if (mapped != null && mapped != RuangBukuState.instance.currentRole) {
      RuangBukuState.instance.changeRole(mapped);
    }
  }

  Future<void> _confirmLogout() async {
    final textTheme = Theme.of(context).textTheme;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: RuangBukuColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: RuangBukuRadius.borderRadiusXl,
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: RuangBukuSpacing.xl,
        ),
        child: Padding(
          padding: const EdgeInsets.all(RuangBukuSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(RuangBukuSpacing.lg),
                decoration: BoxDecoration(
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
                'Keluar dari Akun',
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RuangBukuSpacing.sm),
              Text(
                'Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun.',
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
                      child: const Text('Batal'),
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
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldLogout == true) {
      // Reactive gate in main.dart returns to LoginScreen once unauthenticated.
      await AuthNotifier.instance.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: Listenable.merge([
        RuangBukuState.instance,
        AuthNotifier.instance,
      ]),
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final auth = AuthNotifier.instance;
        final user = auth.user;

        // Dynamic stats calculations
        final ownedCount = state.books
            .where((b) => b.ownerId == 'user_alex')
            .length;

        final borrowedCount = state.borrowings
            .where(
              (b) =>
                  b.borrowerId == 'user_alex' &&
                  (b.status == BorrowStatus.bookReceived ||
                      b.status == BorrowStatus.returnedGood ||
                      b.status == BorrowStatus.returnedDamaged),
            )
            .length;

        final lentCount = state.borrowings.where((b) {
          final bookList = state.books.where(
            (bk) => bk.id == b.bookId && bk.ownerId == 'user_alex',
          );
          return bookList.isNotEmpty &&
              (b.status == BorrowStatus.bookReceived ||
                  b.status == BorrowStatus.returnedGood ||
                  b.status == BorrowStatus.returnedDamaged);
        }).length;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await auth.fetchProfile();
              _syncRoleToAppState();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
              child: Column(
                children: [
                  _buildHeader(context, user, auth.isProfileLoading),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Stats Row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: RuangBukuSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: RuangBukuRadius.borderRadiusLg,
                      boxShadow: RuangBukuElevation.level1,
                      border: Border.all(
                        color: RuangBukuColors.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(
                          context,
                          ownedCount.toString(),
                          'Books Owned',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: RuangBukuColors.divider,
                        ),
                        _buildStatColumn(
                          context,
                          borrowedCount.toString(),
                          'Borrowed',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: RuangBukuColors.divider,
                        ),
                        _buildStatColumn(context, lentCount.toString(), 'Lent'),
                      ],
                    ),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Menu Options
                  _buildMenuTile(
                    context,
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    context,
                    icon: Icons.payment_outlined,
                    title: 'Payment Details',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    context,
                    icon: Icons.history,
                    title: 'Borrowing History',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),

                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Logout
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RuangBukuColors.error,
                      side: const BorderSide(
                        color: RuangBukuColors.error,
                        width: 1.5,
                      ),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: RuangBukuRadius.borderRadiusLg,
                      ),
                    ),
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar'),
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user, bool isLoading) {
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
            style: textTheme.bodyMedium?.copyWith(
              color: RuangBukuColors.textSecondary,
            ),
          ),
          if (roleName != null) ...[
            const SizedBox(height: RuangBukuSpacing.md),
            _buildRoleChip(context, roleName),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleChip(BuildContext context, String roleName) {
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
          const Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: RuangBukuColors.primary,
          ),
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

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            color: RuangBukuColors.primary,
          ),
        ),
        const SizedBox(height: RuangBukuSpacing.xs),
        Text(label, style: textTheme.labelSmall),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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
      trailing: const Icon(
        Icons.chevron_right,
        color: RuangBukuColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
