import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/logout_dialog.dart';
import 'payment_page.dart';
import 'edit_profile_page.dart';
import 'help_support_page.dart';
import '../../borrowing/screens/borrowing_list_page.dart';

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
    final shouldLogout = await showLogoutDialog(context);
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

        final currentUserId = auth.user?.id ?? '';

        final ownedCount =
            state.books.where((b) => b.ownerId == currentUserId).length;

        final borrowedCount = state.borrowings
            .where((b) =>
                b.borrowerId == currentUserId && _isHeldOrReturned(b))
            .length;

        final lentCount = state.borrowings.where((b) {
          final isMine = state.books
              .any((bk) => bk.id == b.bookId && bk.ownerId == currentUserId);
          return isMine && _isHeldOrReturned(b);
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
                  ProfileHeader(
                    user: auth.user,
                    isLoading: auth.isProfileLoading,
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),
                  ProfileStatsRow(
                    ownedCount: ownedCount,
                    borrowedCount: borrowedCount,
                    lentCount: lentCount,
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Menu Options
                  ProfileMenuTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ProfileMenuTile(
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
                  ProfileMenuTile(
                    icon: Icons.history,
                    title: 'Borrowing History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BorrowingListPage(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ProfileMenuTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportPage(),
                      ),
                    ),
                  ),

                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Logout
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RuangBukuColors.error,
                      side: const BorderSide(
                          color: RuangBukuColors.error, width: 1.5),
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

  bool _isHeldOrReturned(BorrowModel b) =>
      b.status == BorrowStatus.bookReceived ||
      b.status == BorrowStatus.returnedGood ||
      b.status == BorrowStatus.returnedDamaged;
}
