import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n?.paymentDetails ?? 'Payment Details',
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
              l10n?.paymentDesc ?? 'Gunakan detail berikut untuk memverifikasi pembayaran deposit atau mentransfer dana.',
              style: textTheme.bodyLarge?.copyWith(
                color: RuangBukuColors.textSecondary,
              ),
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
                leading: const Icon(Icons.account_balance_outlined, color: RuangBukuColors.primary),
                title: Text(l10n?.bankTransfer ?? 'Bank Transfer', style: textTheme.titleMedium),
                subtitle: Text('BCA 123-456-7890 (a.n. RuangBuku)', style: textTheme.bodySmall),
                trailing: const Icon(Icons.check_circle, color: RuangBukuColors.primary),
              ),
            ),
            const SizedBox(height: RuangBukuSpacing.xxl),

            Text(
              l10n?.addNewMethod ?? 'Add New Method',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: RuangBukuSpacing.md),

            ListTile(
              tileColor: theme.colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: RuangBukuRadius.borderRadiusLg,
              ),
              leading: const Icon(Icons.account_balance),
              title: Text(l10n?.bankTransfer ?? 'Bank Transfer', style: textTheme.titleMedium),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
            const SizedBox(height: RuangBukuSpacing.md),

            ListTile(
              tileColor: theme.colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: RuangBukuRadius.borderRadiusLg,
              ),
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text(l10n?.eWallet ?? 'E-Wallet', style: textTheme.titleMedium),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

