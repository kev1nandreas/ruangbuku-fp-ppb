import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/borrowing_transaction_card.dart';
import '../widgets/incoming_request_card.dart';

class UserBorrowingPage extends StatelessWidget {
  const UserBorrowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    Widget sectionTitle(String text) => Text(
          text,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        );

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final borrowings = state.borrowings;
        final incoming = state.incomingRequests;
        final activeIncoming = state.ownerBorrowings
            .where((b) => b.status != BorrowStatus.requested)
            .toList();
        final isEmpty =
            borrowings.isEmpty && incoming.isEmpty && activeIncoming.isEmpty;

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
            child: isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      EmptyStateView(
                        icon: Icons.handshake_outlined,
                        title: l10n?.noTransactions ?? 'Belum Ada Transaksi',
                        message: l10n?.noTransactionsMsg ??
                            'Anda belum memiliki transaksi peminjaman buku.',
                      ),
                    ],
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                    children: [
                      // Incoming requests on books this user owns.
                      if (incoming.isNotEmpty) ...[
                        sectionTitle(
                            l10n?.incomingRequests ?? 'Permintaan Masuk'),
                        const SizedBox(height: RuangBukuSpacing.md),
                        ...incoming.map((b) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: RuangBukuSpacing.md),
                              child: IncomingRequestCard(borrowing: b),
                            )),
                        const SizedBox(height: RuangBukuSpacing.lg),
                      ],

                      // Owned books currently borrowed by others.
                      if (activeIncoming.isNotEmpty) ...[
                        sectionTitle('Buku Terpinjam'),
                        const SizedBox(height: RuangBukuSpacing.md),
                        ..._spacedCards(activeIncoming, isLender: true),
                        const SizedBox(height: RuangBukuSpacing.lg),
                      ],

                      if (borrowings.isNotEmpty) ...[
                        sectionTitle('Buku Dipinjam'),
                        const SizedBox(height: RuangBukuSpacing.md),
                        ..._spacedCards(borrowings, isLender: false),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }

  /// Builds transaction cards separated by vertical gaps.
  Iterable<Widget> _spacedCards(
    List<BorrowModel> items, {
    required bool isLender,
  }) sync* {
    for (var i = 0; i < items.length; i++) {
      if (i > 0) yield const SizedBox(height: RuangBukuSpacing.md);
      yield BorrowingTransactionCard(borrowing: items[i], isLender: isLender);
    }
  }
}
