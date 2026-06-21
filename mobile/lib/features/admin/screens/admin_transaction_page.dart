import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../user/widgets/borrowing_transaction_card.dart';

class AdminTransactionPage extends StatelessWidget {
  const AdminTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final borrowings = state.borrowings;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.borrowings ?? 'Peminjaman',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => state.fetchBorrowings(),
            child: borrowings.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      EmptyStateView(
                        icon: Icons.handshake_outlined,
                        title: l10n?.noTransactions ?? 'Belum Ada Transaksi',
                        message:
                            'Tidak ada transaksi peminjaman di platform ini.',
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    itemCount: borrowings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: RuangBukuSpacing.md),
                    itemBuilder: (context, index) => BorrowingTransactionCard(
                      borrowing: borrowings[index],
                      isLender: true,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
