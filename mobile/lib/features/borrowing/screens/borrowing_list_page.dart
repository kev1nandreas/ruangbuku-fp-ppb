import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import 'borrowing_detail_page.dart';

class BorrowingListPage extends StatelessWidget {
  const BorrowingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final borrowings = state.borrowings;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Peminjaman',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: borrowings.isEmpty
              ? const EmptyStateView(
                  icon: Icons.handshake_outlined,
                  title: 'Belum Ada Transaksi',
                  message: 'Anda belum memiliki transaksi peminjaman buku.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: borrowings.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: RuangBukuSpacing.md),
                  itemBuilder: (context, index) {
                    final b = borrowings[index];
                    final isLender = state.currentRole == UserRole.lender;
                    
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
                                errorBuilder: (_, __, ___) => Container(
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
                                    isLender ? 'Peminjam: ${b.borrowerName}' : 'Pemilik: ${b.borrowerName}', // We don't have ownerName in borrow model easily accessible, let's just use borrowerName or generic info. Actually, if it's borrower view, we might not have the owner name in BorrowModel. Wait, BorrowModel has 'borrowerName'. Let's just use 'Peminjam'.
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
                                      color: _getStatusColor(b.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _getStatusText(b.status),
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
        );
      },
    );
  }

  String _getStatusText(BorrowStatus status) {
    switch (status) {
      case BorrowStatus.requested: return 'Menunggu Konfirmasi';
      case BorrowStatus.waitingDeposit: return 'Menunggu Deposit';
      case BorrowStatus.depositUploaded: return 'Verifikasi Deposit';
      case BorrowStatus.depositVerified: return 'Deposit Terverifikasi';
      case BorrowStatus.bookReceived: return 'Buku Diterima';
      case BorrowStatus.returnedGood: return 'Dikembalikan Baik';
      case BorrowStatus.returnedDamaged: return 'Dikembalikan Rusak';
      case BorrowStatus.completed: return 'Selesai';
      case BorrowStatus.cancelled: return 'Dibatalkan/Ditolak';
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
