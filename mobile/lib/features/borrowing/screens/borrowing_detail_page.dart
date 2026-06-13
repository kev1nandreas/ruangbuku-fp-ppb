import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../notifications/widgets/dispute_resolution_dialog.dart';
import '../widgets/borrow_progress_timeline.dart';
import '../widgets/return_inspection_dialog.dart';
import '../widgets/deposit_proof.dart';
import '../../../l10n/app_localizations.dart';

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
        final l10n = AppLocalizations.of(context);
        
        // Find the borrowing model
        final index = state.borrowings.indexWhere((b) => b.id == borrowingId);
        if (index == -1) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n?.borrowingDetailsTitle ?? 'Detail Peminjaman')),
            body: Center(child: Text(l10n?.transactionNotFound ?? 'Transaksi tidak ditemukan')),
          );
        }
        
        final b = state.borrowings[index];
        final isLender = state.currentRole == UserRole.lender;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.borrowingDetailsTitle ?? 'Detail Peminjaman',
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
                          errorBuilder: (context, error, stackTrace) => Container(
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
                                color: _getStatusColor(b.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getStatusText(b.status, l10n),
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
                Text(l10n?.transactionInfo ?? 'Informasi Transaksi', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: RuangBukuSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(RuangBukuSpacing.md),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context, 
                        label: isLender ? (l10n?.borrowerLabel ?? 'Peminjam') : (l10n?.ownerLabel ?? 'Pemilik Buku'), 
                        value: b.borrowerName, // Usually borrowerName is the only one in the model.
                        icon: Icons.person_outline
                      ),
                      const Divider(),
                      _buildDetailRow(
                        context, 
                        label: l10n?.borrowingDate ?? 'Tanggal Peminjaman', 
                        value: '${_formatDate(b.startDate)} - ${_formatDate(b.endDate)}',
                        icon: Icons.calendar_today_outlined
                      ),
                      const Divider(),
                      _buildDetailRow(
                        context, 
                        label: l10n?.depositAmountLabel ?? 'Nominal Deposit', 
                        value: 'Rp ${b.depositAmount.toStringAsFixed(0)}',
                        icon: Icons.payments_outlined
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: RuangBukuSpacing.xl),

                // Lifecycle progress timeline.
                Text(l10n?.borrowingProgress ?? 'Progres Peminjaman', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: RuangBukuSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(RuangBukuSpacing.md),
                  child: BorrowProgressTimeline(status: b.status, borrow: b),
                ),

                // If there's a damage report
                if (b.damageReport != null) ...[
                  const SizedBox(height: RuangBukuSpacing.xl),
                  Text(l10n?.damageReportLabel ?? 'Laporan Kerusakan', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: RuangBukuSpacing.md),
                  AppCard(
                    padding: const EdgeInsets.all(RuangBukuSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n?.descriptionLabel ?? "Deskripsi"}: ${b.damageReport!.description}', style: textTheme.bodyMedium),
                        const SizedBox(height: RuangBukuSpacing.sm),
                        if (b.damageReport!.deductionAmount > 0)
                          Text(l10n?.depositDeduction(b.damageReport!.deductionAmount.toStringAsFixed(0)) ?? 'Potongan Deposit: Rp ${b.damageReport!.deductionAmount.toStringAsFixed(0)}',
                            style: textTheme.bodyMedium?.copyWith(color: RuangBukuColors.error, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],

                // Borrower lifecycle actions (upload deposit / confirm receipt).
                ..._buildBorrowerActions(context, b),

                // Owner lifecycle actions (confirm return / report damage).
                ..._buildOwnerActions(context, b),

                // Admin-only settlement actions (deposit + dispute).
                ..._buildAdminActions(context, b),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Borrower controls: upload the deposit proof after approval, then confirm
  /// the book was handed over. Shown only to the borrower of this borrow.
  List<Widget> _buildBorrowerActions(BuildContext context, BorrowModel b) {
    final currentUserId = AuthNotifier.instance.user?.id ?? '';
    if (b.borrowerId != currentUserId) return const [];

    final state = RuangBukuState.instance;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    Future<void> run(Future<void> Function() action, String okMsg) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await action();
        messenger.showSnackBar(SnackBar(content: Text(okMsg)));
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(l10n?.failed(e.toString()) ?? 'Gagal: $e')));
      }
    }

    String message;
    Widget control;
    switch (b.status) {
      case BorrowStatus.requested:
        message = l10n?.waitingOwnerApproval ?? 'Menunggu persetujuan pemilik buku.';
        control = OutlinedButton(
            onPressed: null, child: Text(l10n?.statusRequested ?? 'Menunggu Konfirmasi'));
        break;
      case BorrowStatus.waitingDeposit:
        message = l10n?.approvedUploadDeposit ?? 'Disetujui! Unggah bukti deposit untuk melanjutkan.';
        control = FilledButton.icon(
          icon: const Icon(Icons.upload_file_outlined),
          onPressed: () => pickAndUploadDepositProof(context, b.id),
          label: Text(l10n?.uploadDepositProof ?? 'Unggah Bukti Deposit (Rp 50.000)'),
        );
        break;
      case BorrowStatus.depositUploaded:
        message = l10n?.depositSent ?? 'Bukti deposit terkirim.';
        control = Column(
          children: [
            if (b.paymentProofUrl != null && b.paymentProofUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  onPressed: () =>
                      showDepositProofViewer(context, b.paymentProofUrl!),
                  label: Text(l10n?.viewDepositProof ?? 'Lihat Bukti Deposit'),
                ),
              ),
            const SizedBox(height: RuangBukuSpacing.sm),
            OutlinedButton(
                onPressed: null, child: Text(l10n?.waitingAdminVerification ?? 'Menunggu Verifikasi Admin')),
          ],
        );
        break;
      case BorrowStatus.depositVerified:
        message = l10n?.depositVerifiedTakeBook ?? 'Deposit terverifikasi. Ambil buku, lalu konfirmasi.';
        control = FilledButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () => run(
            () => state.confirmBookReceived(b.id),
            l10n?.bookConfirmedReceived ?? 'Buku dikonfirmasi diterima.',
          ),
          label: Text(l10n?.confirmBookReceived ?? 'Konfirmasi Buku Diterima'),
        );
        break;
      case BorrowStatus.bookReceived:
        message = l10n?.youHoldBook ?? 'Anda memegang buku ini. Koordinasi pengembalian dengan pemilik.';
        control =
            OutlinedButton(onPressed: null, child: Text(l10n?.currentlyBorrowed ?? 'Sedang Dipinjam'));
        break;
      case BorrowStatus.returnedGood:
        message = l10n?.bookReturnedGoodWaitingDeposit ?? 'Buku dikembalikan baik. Menunggu pengembalian deposit.';
        control = OutlinedButton(
            onPressed: null, child: Text(l10n?.waitingDepositReturn ?? 'Menunggu Pengembalian Deposit'));
        break;
      case BorrowStatus.returnedDamaged:
        message = l10n?.reportedDamagedWaitingAdmin ?? 'Dilaporkan rusak. Menunggu penyelesaian admin.';
        control = OutlinedButton(
            onPressed: null, child: Text(l10n?.disputeOpened ?? 'Sengketa Dibuka'));
        break;
      case BorrowStatus.completed:
      case BorrowStatus.cancelled:
        return const [];
    }

    return [
      const SizedBox(height: RuangBukuSpacing.xl),
      Text(l10n?.borrowerActions ?? 'Tindakan Peminjam',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: RuangBukuSpacing.sm),
      Text(message,
          style: textTheme.bodySmall
              ?.copyWith(color: RuangBukuColors.textSecondary)),
      const SizedBox(height: RuangBukuSpacing.md),
      SizedBox(width: double.infinity, child: control),
    ];
  }

  /// Owner controls for the in-hand stage: confirm a clean return or report
  /// damage. Both backend routes (`confirm-return`, `report-damage`) are
  /// owner-gated, so this is shown only when the user views as the lender.
  List<Widget> _buildOwnerActions(BuildContext context, BorrowModel b) {
    final state = RuangBukuState.instance;
    final isOwnerView = state.currentRole == UserRole.lender;
    if (!isOwnerView || b.status != BorrowStatus.bookReceived) return const [];

    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return [
      const SizedBox(height: RuangBukuSpacing.xl),
      Text(l10n?.ownerActions ?? 'Tindakan Pemilik',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: RuangBukuSpacing.sm),
      Text(
        l10n?.borrowerHoldsBook ?? 'Peminjam sedang memegang buku. Saat dikembalikan, konfirmasi kondisinya.',
        style: textTheme.bodySmall?.copyWith(color: RuangBukuColors.textSecondary),
      ),
      const SizedBox(height: RuangBukuSpacing.md),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          icon: const Icon(Icons.fact_check_outlined),
          onPressed: () => showReturnInspectionDialog(context, b),
          label: Text(l10n?.confirmReturn ?? 'Konfirmasi Pengembalian'),
        ),
      ),
    ];
  }

  /// Admin controls for deposit confirmation and dispute settlement.
  /// Gated by the real account role (`admin`), not the UI role toggle, since
  /// the backend protects these routes with `role:admin`.
  List<Widget> _buildAdminActions(BuildContext context, BorrowModel b) {
    final isAdmin = AuthNotifier.instance.user?.primaryRoleName == 'admin';
    if (!isAdmin) return const [];

    final state = RuangBukuState.instance;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    Future<void> run(Future<void> Function() action, String okMsg) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await action();
        messenger.showSnackBar(SnackBar(content: Text(okMsg)));
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(l10n?.failed(e.toString()) ?? 'Gagal: $e')));
      }
    }

    Widget? control;
    switch (b.status) {
      case BorrowStatus.depositUploaded:
        control = Column(
          children: [
            if (b.paymentProofUrl != null && b.paymentProofUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  onPressed: () =>
                      showDepositProofViewer(context, b.paymentProofUrl!),
                  label: Text(l10n?.viewDepositProof ?? 'Lihat Bukti Deposit'),
                ),
              ),
            const SizedBox(height: RuangBukuSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.verified_outlined),
                onPressed: () => run(
                  () => state.verifyDepositPayment(b.id, true),
                  l10n?.depositConfirmed ?? 'Deposit dikonfirmasi.',
                ),
                label: Text(l10n?.confirmDepositAdmin ?? 'Konfirmasi Deposit'),
              ),
            ),
          ],
        );
        break;
      case BorrowStatus.returnedGood:
        control = FilledButton.icon(
          icon: const Icon(Icons.assignment_return_outlined),
          onPressed: () => run(
            () => state.returnDeposit(b.id),
            l10n?.depositReturnedToBorrower ?? 'Deposit dikembalikan ke peminjam.',
          ),
          label: Text(l10n?.returnDepositToBorrower ?? 'Kembalikan Deposit ke Peminjam'),
        );
        break;
      case BorrowStatus.returnedDamaged:
        control = FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: RuangBukuColors.error),
          icon: const Icon(Icons.gavel_outlined),
          onPressed: () => showDisputeResolutionDialog(context, b),
          label: Text(l10n?.settleDamageDispute ?? 'Selesaikan Sengketa Kerusakan'),
        );
        break;
      default:
        control = null;
    }

    if (control == null) return const [];

    return [
      const SizedBox(height: RuangBukuSpacing.xl),
      Text(l10n?.adminActions ?? 'Tindakan Admin',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: RuangBukuSpacing.md),
      SizedBox(width: double.infinity, child: control),
    ];
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
