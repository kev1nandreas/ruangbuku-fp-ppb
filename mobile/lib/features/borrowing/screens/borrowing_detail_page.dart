import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';

class BorrowingDetailPage extends StatelessWidget {
  final String borrowingId;

  const BorrowingDetailPage({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        
        // Find the borrowing model
        final index = state.borrowings.indexWhere((b) => b.id == borrowingId);
        if (index == -1) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Peminjaman')),
            body: const Center(child: Text('Transaksi tidak ditemukan')),
          );
        }
        
        final b = state.borrowings[index];
        final isLender = state.currentRole == UserRole.lender;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Detail Peminjaman',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Info Card
                AppCard(
                  padding: const EdgeInsets.all(RuangBukuSpacing.md),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: RuangBukuRadius.borderRadiusSm,
                        child: Image.network(
                          b.bookImageUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: RuangBukuSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.bookTitle,
                              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b.bookAuthor,
                              style: textTheme.bodyLarge?.copyWith(color: RuangBukuColors.textSecondary),
                            ),
                            const SizedBox(height: RuangBukuSpacing.md),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(b.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getStatusText(b.status),
                                style: textTheme.labelLarge?.copyWith(
                                  color: _getStatusColor(b.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RuangBukuSpacing.xl),

                // Transaction Details
                Text('Informasi Transaksi', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: RuangBukuSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(RuangBukuSpacing.md),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context, 
                        label: isLender ? 'Peminjam' : 'Pemilik Buku', 
                        value: b.borrowerName, // Usually borrowerName is the only one in the model.
                        icon: Icons.person_outline
                      ),
                      const Divider(),
                      _buildDetailRow(
                        context, 
                        label: 'Tanggal Peminjaman', 
                        value: '${_formatDate(b.startDate)} - ${_formatDate(b.endDate)}',
                        icon: Icons.calendar_today_outlined
                      ),
                      const Divider(),
                      _buildDetailRow(
                        context, 
                        label: 'Nominal Deposit', 
                        value: 'Rp ${b.depositAmount.toStringAsFixed(0)}',
                        icon: Icons.payments_outlined
                      ),
                    ],
                  ),
                ),
                
                // If there's a damage report
                if (b.damageReport != null) ...[
                  const SizedBox(height: RuangBukuSpacing.xl),
                  Text('Laporan Kerusakan', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: RuangBukuSpacing.md),
                  AppCard(
                    padding: const EdgeInsets.all(RuangBukuSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deskripsi: ${b.damageReport!.description}', style: textTheme.bodyMedium),
                        const SizedBox(height: RuangBukuSpacing.sm),
                        if (b.damageReport!.deductionAmount > 0)
                          Text('Potongan Deposit: Rp ${b.damageReport!.deductionAmount.toStringAsFixed(0)}', 
                            style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.error, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, {required String label, required String value, required IconData icon}) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: RuangBukuColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(label, style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.textSecondary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value, 
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
