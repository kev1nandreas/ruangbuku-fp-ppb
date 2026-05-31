import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import 'payment_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        // Dynamic stats calculations
        final ownedCount = state.books.where((b) => b.ownerId == 'user_alex').length;
        
        final borrowedCount = state.borrowings.where((b) => 
          b.borrowerId == 'user_alex' && 
          (b.status == BorrowStatus.bookReceived || b.status == BorrowStatus.returnedGood || b.status == BorrowStatus.returnedDamaged)
        ).length;

        final lentCount = state.borrowings.where((b) {
          final bookList = state.books.where((bk) => bk.id == b.bookId && bk.ownerId == 'user_alex');
          return bookList.isNotEmpty && 
            (b.status == BorrowStatus.bookReceived || b.status == BorrowStatus.returnedGood || b.status == BorrowStatus.returnedDamaged);
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            child: Column(
              children: [
                // User Header
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage('https://picsum.photos/seed/user_alex/100/100'),
                      ),
                      const SizedBox(height: RuangBukuSpacing.lg),
                      Text('Alex Johnson', style: textTheme.headlineSmall),
                      const SizedBox(height: RuangBukuSpacing.xs),
                      Text(
                        'alex.j@example.com',
                        style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xl),

                // Role Switcher Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.lg, vertical: RuangBukuSpacing.sm),
                  decoration: BoxDecoration(
                    color: RuangBukuColors.surfaceContainerLow,
                    borderRadius: RuangBukuRadius.borderRadiusLg,
                    border: Border.all(
                      color: RuangBukuColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<UserRole>(
                      decoration: const InputDecoration(
                        labelText: 'Simulation Role',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      value: state.currentRole,
                      items: const [
                        DropdownMenuItem(
                          value: UserRole.borrower,
                          child: Text('Peminjam (Borrower)', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DropdownMenuItem(
                          value: UserRole.lender,
                          child: Text('Pemilik (Lender)', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        DropdownMenuItem(
                          value: UserRole.admin,
                          child: Text('System Admin (Admin)', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                      onChanged: (newRole) {
                        if (newRole != null) {
                          state.changeRole(newRole);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Switched to ${newRole.toString().split('.').last.toUpperCase()} view'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xxl),

                // Stats Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: RuangBukuRadius.borderRadiusLg,
                    boxShadow: RuangBukuElevation.level1,
                    border: Border.all(
                      color: RuangBukuColors.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(context, ownedCount.toString(), 'Books Owned'),
                      Container(width: 1, height: 40, color: RuangBukuColors.divider),
                      _buildStatColumn(context, borrowedCount.toString(), 'Borrowed'),
                      Container(width: 1, height: 40, color: RuangBukuColors.divider),
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

                // Logout / Delete Account
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RuangBukuColors.error,
                    side: const BorderSide(color: RuangBukuColors.error, width: 1.5),
                  ),
                  onPressed: () {},
                  child: const Text('Delete Account'),
                ),
                const SizedBox(height: RuangBukuSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.headlineSmall?.copyWith(color: RuangBukuColors.primary)),
        const SizedBox(height: RuangBukuSpacing.xs),
        Text(label, style: textTheme.labelSmall),
      ],
    );
  }

  Widget _buildMenuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
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
      trailing: const Icon(Icons.chevron_right, color: RuangBukuColors.textSecondary),
      onTap: onTap,
    );
  }
}
