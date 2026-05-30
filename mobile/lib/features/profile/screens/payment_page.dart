import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Details',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Linked Accounts',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            
            // Existing Payment Method
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: RuangBukuRadius.borderRadiusLg,
                boxShadow: RuangBukuElevation.level1,
                border: Border.all(
                  color: RuangBukuColors.primary,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet, color: RuangBukuColors.primary),
                title: Text('GoPay', style: textTheme.titleMedium),
                subtitle: Text('0812-XXXX-XXXX', style: textTheme.bodySmall),
                trailing: const Icon(Icons.check_circle, color: RuangBukuColors.primary),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            Text(
              'Add New Method',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),

            // Add Bank
            ListTile(
              tileColor: RuangBukuColors.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: RuangBukuRadius.borderRadiusLg,
              ),
              leading: const Icon(Icons.account_balance),
              title: Text('Bank Transfer', style: textTheme.titleMedium),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
            const SizedBox(height: RuangBukuSpacing.md),

            // Add E-Wallet
            ListTile(
              tileColor: RuangBukuColors.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: RuangBukuRadius.borderRadiusLg,
              ),
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text('E-Wallet', style: textTheme.titleMedium),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

