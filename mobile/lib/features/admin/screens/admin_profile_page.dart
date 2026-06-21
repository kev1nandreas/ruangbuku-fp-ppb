import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../profile/widgets/profile_header.dart';
import '../../profile/widgets/profile_menu_tile.dart';
import '../../profile/widgets/logout_dialog.dart';
import '../../profile/screens/edit_profile_page.dart';
import '../../profile/screens/help_support_page.dart';
import '../../profile/screens/settings_page.dart';
import '../../../l10n/app_localizations.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
      if (mounted) {
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
      }
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
        final auth = AuthNotifier.instance;

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
}
