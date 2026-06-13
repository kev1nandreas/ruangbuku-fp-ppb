import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import 'borrowing_detail_page.dart';
import '../../../l10n/app_localizations.dart';

class BorrowingListPage extends StatelessWidget {
  const BorrowingListPage({super.key});

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
        final incoming = state.incomingRequests;

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
            child: (borrowings.isEmpty && incoming.isEmpty)
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    EmptyStateView(
                      icon: Icons.handshake_outlined,
                      title: l10n?.noTransactions ?? 'Belum Ada Transaksi',
                      message: l10n?.noTransactionsMsg ?? 'Anda belum memiliki transaksi peminjaman buku.',
                    ),
                  ],
                )
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  children: [
                    // Incoming requests on books this user owns. Shown to anyone
                    // who owns a book, independent of the role toggle.
                    if (incoming.isNotEmpty) ...[
                      Text(l10n?.incomingRequests ?? 'Permintaan Masuk',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: RuangBukuSpacing.md),
                      ...incoming.map((b) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: RuangBukuSpacing.md),
                            child: _IncomingRequestCard(borrowing: b),
                          )),
                      const SizedBox(height: RuangBukuSpacing.lg),
                      Text(l10n?.yourTransactions ?? 'Transaksi Anda',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: RuangBukuSpacing.md),
                    ],
                    ...borrowings.asMap().entries.expand((entry) {
                      final index = entry.key;
                      final b = entry.value;
                      final isLender = state.currentRole == UserRole.lender;

                      return [
                        if (index > 0)
                          const SizedBox(height: RuangBukuSpacing.md),
                        InkWell(
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
                                    isLender ? (l10n?.borrowerName(b.borrowerName) ?? 'Peminjam: ${b.borrowerName}') : (l10n?.ownerName(b.borrowerName) ?? 'Pemilik: ${b.borrowerName}'),
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
                    ),
                      ];
                    }),
                  ],
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

/// Card for a pending borrow request on a book the current user owns, with
/// inline Accept / Reject controls wired to the approve/reject routes.
class _IncomingRequestCard extends StatefulWidget {
  const _IncomingRequestCard({required this.borrowing});

  final BorrowModel borrowing;

  @override
  State<_IncomingRequestCard> createState() => _IncomingRequestCardState();
}

class _IncomingRequestCardState extends State<_IncomingRequestCard> {
  bool _busy = false;

  Future<void> _respond(bool approve) async {
    final b = widget.borrowing;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    try {
      await RuangBukuState.instance.respondToBorrowRequest(b.id, approve);
      messenger.showSnackBar(SnackBar(
        content: Text(approve ? (l10n?.requestAccepted ?? 'Permintaan diterima.') : (l10n?.requestRejected ?? 'Permintaan ditolak.')),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n?.failed(e.toString()) ?? 'Gagal: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final b = widget.borrowing;

    String fmt(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      decoration: BoxDecoration(
        color: RuangBukuColors.surface,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        border: Border.all(color: RuangBukuColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: RuangBukuRadius.borderRadiusSm,
                child: Image.network(
                  b.bookImageUrl,
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
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
                    Text(b.bookTitle,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(l10n?.borrowerName(b.borrowerName) ?? 'Peminjam: ${b.borrowerName}',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: RuangBukuColors.textSecondary)),
                    Text('${fmt(b.startDate)} - ${fmt(b.endDate)}',
                        style: textTheme.bodySmall
                            ?.copyWith(color: RuangBukuColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RuangBukuSpacing.md),
          if (_busy)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RuangBukuColors.error,
                      side: const BorderSide(color: RuangBukuColors.error),
                    ),
                    onPressed: () => _respond(false),
                    child: Text(l10n?.reject ?? 'Tolak'),
                  ),
                ),
                const SizedBox(width: RuangBukuSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _respond(true),
                    child: Text(l10n?.accept ?? 'Terima'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
