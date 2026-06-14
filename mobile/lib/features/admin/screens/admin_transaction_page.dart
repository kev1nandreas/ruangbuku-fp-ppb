import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../borrowing/screens/borrowing_detail_page.dart';
import '../../../l10n/app_localizations.dart';

class AdminTransactionPage extends StatelessWidget {
  const AdminTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
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
                      message: 'Tidak ada transaksi peminjaman di platform ini.',
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: borrowings.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: RuangBukuSpacing.md),
                  itemBuilder: (context, index) {
                    final b = borrowings[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BorrowingDetailPage(borrowingId: b.id),
                          ),
                        );
                      },
                      borderRadius: RuangBukuRadius.borderRadiusLg,
                      child: Container(
                        padding: const EdgeInsets.all(RuangBukuSpacing.md),
                        decoration: BoxDecoration(
                          color: RuangBukuColors.surface,
                          borderRadius: RuangBukuRadius.borderRadiusLg,
                          border: Border.all(color: RuangBukuColors.outlineVariant),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: RuangBukuRadius.borderRadiusSm,
                              child: Image.network(
                                b.bookImageUrl,
                                width: 50,
                                height: 75,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 75,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.book, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: RuangBukuSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.bookTitle,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n?.borrowerName(b.borrowerName) ?? 'Peminjam: ${b.borrowerName}',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: RuangBukuColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(b.status).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _getStatusText(b.status, l10n),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: _getStatusColor(b.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: RuangBukuColors.textSecondary),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        );
      },
    );
  }

  String _getStatusText(BorrowStatus status, AppLocalizations? l10n) {
    switch (status) {
      case BorrowStatus.requested: return l10n?.statusRequested ?? 'Menunggu Konfirmasi';
      case BorrowStatus.waitingDeposit: return l10n?.statusWaitingDeposit ?? 'Menunggu Deposit';
      case BorrowStatus.depositUploaded: return l10n?.statusDepositUploaded ?? 'Verifikasi Deposit';
      case BorrowStatus.depositVerified: return l10n?.statusDepositVerified ?? 'Deposit Terverifikasi';
      case BorrowStatus.bookReceived: return l10n?.statusBookReceived ?? 'Buku Diterima';
      case BorrowStatus.returnedGood: return l10n?.statusReturnedGood ?? 'Dikembalikan Baik';
      case BorrowStatus.returnedDamaged: return l10n?.statusReturnedDamaged ?? 'Dikembalikan Rusak';
      case BorrowStatus.completed: return l10n?.statusCompleted ?? 'Selesai';
      case BorrowStatus.cancelled: return l10n?.statusCancelled ?? 'Dibatalkan/Ditolak';
    }
  }

  Color _getStatusColor(BorrowStatus status) {
    switch (status) {
      case BorrowStatus.requested:
      case BorrowStatus.waitingDeposit:
      case BorrowStatus.depositUploaded:
        return Colors.orange;
      case BorrowStatus.depositVerified:
      case BorrowStatus.bookReceived:
      case BorrowStatus.returnedGood:
      case BorrowStatus.completed:
        return Colors.green;
      case BorrowStatus.returnedDamaged:
      case BorrowStatus.cancelled:
        return Colors.red;
    }
  }
}
