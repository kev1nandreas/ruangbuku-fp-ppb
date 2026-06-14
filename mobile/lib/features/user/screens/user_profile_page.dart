import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../profile/widgets/profile_header.dart';
import '../../profile/widgets/profile_stats_row.dart';
import '../../profile/widgets/profile_menu_tile.dart';
import '../../profile/widgets/logout_dialog.dart';
import '../../profile/screens/payment_page.dart';
import '../../profile/screens/edit_profile_page.dart';
import '../../profile/screens/help_support_page.dart';
import '../../profile/screens/settings_page.dart';
import '../../../l10n/app_localizations.dart';

class UserProfilePage extends StatefulWidget {
  final void Function(int)? onNavigateToTab;

  const UserProfilePage({super.key, this.onNavigateToTab});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthNotifier.instance.fetchProfile();
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showLogoutDialog(context);
    if (shouldLogout == true) {
      await AuthNotifier.instance.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

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

        final uniqueBorrowings = <String, dynamic>{};
        for (var b in state.borrowings) { uniqueBorrowings[b.id] = b; }
        for (var b in state.ownerBorrowings) { uniqueBorrowings[b.id] = b; }
        final allBorrowings = uniqueBorrowings.values;

        final borrowedCount = allBorrowings
            .where((b) =>
                b.borrowerId == currentUserId && _isActiveBorrowing(b))
            .length;

        final lentCount = allBorrowings.where((b) {
          final isMine = state.books
              .any((bk) => bk.id == b.bookId && bk.ownerId == currentUserId);
          return isMine && _isActiveBorrowing(b);
        }).length;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.profile ?? 'Profile',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await auth.fetchProfile();
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
                    onNavigateToTab: widget.onNavigateToTab,
                  ),
                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Menu Options
                  ProfileMenuTile(
                    icon: Icons.person_outline,
                    title: l10n?.editProfile ?? 'Edit Profile',
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
                    title: l10n?.paymentDetails ?? 'Payment Details',
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
                    icon: Icons.help_outline,
                    title: l10n?.helpSupport ?? 'Help & Support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportPage(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ProfileMenuTile(
                    icon: Icons.settings_outlined,
                    title: l10n?.settings ?? 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: RuangBukuSpacing.xxl),

                  // Logout
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.error, width: 1.5),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: RuangBukuRadius.borderRadiusLg,
                      ),
                    ),
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout),
                    label: Text(l10n?.logout ?? 'Keluar'),
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

  bool _isActiveBorrowing(BorrowModel b) =>
      b.status == BorrowStatus.requested ||
      b.status == BorrowStatus.waitingDeposit ||
      b.status == BorrowStatus.depositUploaded ||
      b.status == BorrowStatus.depositVerified ||
      b.status == BorrowStatus.bookReceived;
}
