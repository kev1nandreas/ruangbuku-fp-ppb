import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/detail_row.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/domain/auth_notifier.dart';
import '../../notifications/widgets/dispute_resolution_dialog.dart';
import 'borrow_status_chip.dart';
import 'return_inspection_dialog.dart';
import 'deposit_proof.dart';

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

/// Section title used between cards on the borrowing detail page.
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Book cover + title + author + status chip card at the top of the detail page.
class BorrowBookInfoCard extends StatelessWidget {
  final BorrowModel borrow;
  const BorrowBookInfoCard({super.key, required this.borrow});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: RuangBukuRadius.borderRadiusSm,
            child: Image.network(
              borrow.bookImageUrl,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
              cacheWidth: 240,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 120,
                color: RuangBukuColors.surfaceContainerHigh,
                child: const Icon(Icons.book, size: 40, color: RuangBukuColors.outline),
              ),
            ),
          ),
          const SizedBox(width: RuangBukuSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  borrow.bookTitle,
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  borrow.bookAuthor,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: RuangBukuColors.textSecondary),
                ),
                const SizedBox(height: RuangBukuSpacing.md),
                BorrowStatusChip(status: borrow.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Transaction information card (parties, dates, durations).
class BorrowTransactionInfoCard extends StatelessWidget {
  final BorrowModel borrow;
  final bool isLender;
  const BorrowTransactionInfoCard({
    super.key,
    required this.borrow,
    required this.isLender,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final b = borrow;
    return AppCard(
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      child: Column(
        children: [
          DetailRow(
            label: isLender
                ? (l10n?.borrowerLabel ?? 'Peminjam')
                : (l10n?.ownerLabel ?? 'Pemilik Buku'),
            value: b.borrowerName,
            icon: Icons.person_outline,
          ),
          const Divider(),
          DetailRow(
            label: 'Tanggal Diajukan',
            value: _formatDate(b.createdAt),
            icon: Icons.history_outlined,
          ),
          if (b.verifiedAt != null) ...[
            const Divider(),
            DetailRow(
              label: 'Tanggal Disetujui',
              value: _formatDate(b.verifiedAt!),
              icon: Icons.check_circle_outline,
            ),
          ],
          const Divider(),
          DetailRow(
            label: 'Durasi Peminjaman',
            value: '${_formatDate(b.startDate)} - ${_formatDate(b.endDate)}',
            icon: Icons.calendar_today_outlined,
          ),
          const Divider(),
          DetailRow(
            label: 'Estimasi Selesai',
            value: _formatDate(b.endDate),
            icon: Icons.event_available_outlined,
          ),
          const Divider(),
          DetailRow(
            label: 'Tanggal Dikembalikan',
            value: b.returnedAt != null
                ? _formatDate(b.returnedAt!)
                : 'Masih dipinjam',
            icon: Icons.assignment_return_outlined,
          ),
        ],
      ),
    );
  }
}

/// Damage report card; render only when [borrow.damageReport] is non-null.
class BorrowDamageReportCard extends StatelessWidget {
  final BorrowModel borrow;
  const BorrowDamageReportCard({super.key, required this.borrow});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final report = borrow.damageReport!;
    return AppCard(
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n?.descriptionLabel ?? "Deskripsi"}: ${report.description}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: RuangBukuSpacing.sm),
          if (report.deductionAmount > 0)
            Text(
              l10n?.depositDeduction(report.deductionAmount.toStringAsFixed(0)) ??
                  'Potongan Deposit: Rp ${report.deductionAmount.toStringAsFixed(0)}',
              style: textTheme.bodyMedium?.copyWith(
                color: RuangBukuColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

/// Runs [action] and shows [okMsg] on success or a localized failure snackbar.
Future<void> _runAction(
  BuildContext context,
  Future<void> Function() action,
  String okMsg,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  try {
    await action();
    messenger.showSnackBar(SnackBar(content: Text(okMsg)));
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n?.failed(e.toString()) ?? 'Gagal: $e')),
    );
  }
}

/// WhatsApp contact shortcut for the borrower/owner. Hidden once the borrow is
/// completed or cancelled.
List<Widget> buildContactActions(BuildContext context, BorrowModel b) {
  if (b.status == BorrowStatus.completed ||
      b.status == BorrowStatus.cancelled) {
    return const [];
  }

  final currentUserId = AuthNotifier.instance.user?.id ?? '';
  final isBorrower = b.borrowerId == currentUserId;
  final isOwner =
      RuangBukuState.instance.ownerBorrowings.any((borrow) => borrow.id == b.id);
  if (!isBorrower && !isOwner) return const [];

  final l10n = AppLocalizations.of(context);

  Future<void> openWhatsApp() async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(
      isBorrower ? 'https://wa.me/6281234567890' : 'https://wa.me/6289876543210',
    );
    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n?.failed('Tidak dapat membuka WhatsApp') ??
                'Tidak dapat membuka WhatsApp'),
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              l10n?.failed(e.toString()) ?? 'Gagal membuka WhatsApp: $e'),
        ),
      );
    }
  }

  return [
    const SizedBox(height: RuangBukuSpacing.xl),
    SectionTitle('Hubungi Pihak Terkait'),
    const SizedBox(height: RuangBukuSpacing.sm),
    SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: const Icon(Icons.chat_bubble_outline),
        onPressed: openWhatsApp,
        label: Text(isBorrower ? 'Hubungi Pemilik (WA)' : 'Hubungi Peminjam (WA)'),
      ),
    ),
  ];
}

/// Borrower lifecycle controls (upload deposit, confirm receipt, status hints).
List<Widget> buildBorrowerActions(BuildContext context, BorrowModel b) {
  final currentUserId = AuthNotifier.instance.user?.id ?? '';
  if (b.borrowerId != currentUserId) return const [];

  final state = RuangBukuState.instance;
  final textTheme = Theme.of(context).textTheme;
  final l10n = AppLocalizations.of(context);

  String message;
  Widget control;
  switch (b.status) {
    case BorrowStatus.requested:
      message =
          l10n?.waitingOwnerApproval ?? 'Menunggu persetujuan pemilik buku.';
      control = OutlinedButton(
        onPressed: null,
        child: Text(l10n?.statusRequested ?? 'Menunggu Konfirmasi'),
      );
      break;
    case BorrowStatus.waitingDeposit:
      message = l10n?.approvedUploadDeposit ??
          'Disetujui! Unggah bukti deposit untuk melanjutkan.';
      control = FilledButton.icon(
        icon: const Icon(Icons.upload_file_outlined),
        onPressed: () => pickAndUploadDepositProof(context, b.id),
        label: Text(
            l10n?.uploadDepositProof ?? 'Unggah Bukti Deposit (Rp 50.000)'),
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
            onPressed: null,
            child: Text(
                l10n?.waitingAdminVerification ?? 'Menunggu Verifikasi Admin'),
          ),
        ],
      );
      break;
    case BorrowStatus.depositVerified:
      message = l10n?.depositVerifiedTakeBook ??
          'Deposit terverifikasi. Ambil buku, lalu konfirmasi.';
      control = FilledButton.icon(
        icon: const Icon(Icons.check_circle_outline),
        onPressed: () => _runAction(
          context,
          () => state.confirmBookReceived(b.id),
          l10n?.bookConfirmedReceived ?? 'Buku dikonfirmasi diterima.',
        ),
        label: Text(l10n?.confirmBookReceived ?? 'Konfirmasi Buku Diterima'),
      );
      break;
    case BorrowStatus.bookReceived:
      message = l10n?.youHoldBook ??
          'Anda memegang buku ini. Koordinasi pengembalian dengan pemilik melalui WhatsApp.';
      control = OutlinedButton(
        onPressed: null,
        child: const Text('Sedang Dipinjam'),
      );
      break;
    case BorrowStatus.returnedGood:
      message = l10n?.bookReturnedGoodWaitingDeposit ??
          'Buku dikembalikan baik. Menunggu pengembalian deposit.';
      control = OutlinedButton(
        onPressed: null,
        child:
            Text(l10n?.waitingDepositReturn ?? 'Menunggu Pengembalian Deposit'),
      );
      break;
    case BorrowStatus.returnedDamaged:
      message = l10n?.reportedDamagedWaitingAdmin ??
          'Dilaporkan rusak. Menunggu penyelesaian admin.';
      control = OutlinedButton(
        onPressed: null,
        child: Text(l10n?.disputeOpened ?? 'Sengketa Dibuka'),
      );
      break;
    case BorrowStatus.completed:
    case BorrowStatus.cancelled:
      return const [];
  }

  return [
    const SizedBox(height: RuangBukuSpacing.xl),
    SectionTitle(l10n?.borrowerActions ?? 'Tindakan Peminjam'),
    const SizedBox(height: RuangBukuSpacing.sm),
    Text(
      message,
      style: textTheme.bodySmall
          ?.copyWith(color: RuangBukuColors.textSecondary),
    ),
    const SizedBox(height: RuangBukuSpacing.md),
    SizedBox(width: double.infinity, child: control),
  ];
}

/// Owner controls for the in-hand stage: confirm a clean return or report damage.
List<Widget> buildOwnerActions(BuildContext context, BorrowModel b) {
  final isOwner =
      RuangBukuState.instance.ownerBorrowings.any((borrow) => borrow.id == b.id);
  if (!isOwner || b.status != BorrowStatus.bookReceived) return const [];

  final textTheme = Theme.of(context).textTheme;
  final l10n = AppLocalizations.of(context);

  return [
    const SizedBox(height: RuangBukuSpacing.xl),
    SectionTitle(l10n?.ownerActions ?? 'Tindakan Pemilik'),
    const SizedBox(height: RuangBukuSpacing.sm),
    Text(
      l10n?.borrowerHoldsBook ??
          'Peminjam sedang memegang buku. Saat dikembalikan, konfirmasi kondisinya.',
      style: textTheme.bodySmall
          ?.copyWith(color: RuangBukuColors.textSecondary),
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

/// Admin controls for deposit confirmation and dispute settlement. Gated by the
/// real account role (`admin`), not the UI role toggle.
List<Widget> buildAdminActions(BuildContext context, BorrowModel b) {
  final isAdmin = AuthNotifier.instance.user?.primaryRoleName == 'admin';
  if (!isAdmin) return const [];

  final state = RuangBukuState.instance;
  final l10n = AppLocalizations.of(context);

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
              onPressed: () => _runAction(
                context,
                () => state.verifyDepositPayment(b.id, true),
                l10n?.depositConfirmed ?? 'Deposit dikonfirmasi.',
              ),
              label: Text(l10n?.confirmDepositAdmin ?? 'Konfirmasi Deposit'),
            ),
          ),
          const SizedBox(height: RuangBukuSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: RuangBukuColors.error),
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () => _runAction(
                context,
                () => state.verifyDepositPayment(b.id, false),
                'Deposit ditolak. Menunggu peminjam mengunggah ulang.',
              ),
              label: const Text('Tolak Deposit (Unggah Ulang)'),
            ),
          ),
        ],
      );
      break;
    case BorrowStatus.returnedGood:
      control = FilledButton.icon(
        icon: const Icon(Icons.assignment_return_outlined),
        onPressed: () => _runAction(
          context,
          () => state.returnDeposit(b.id),
          l10n?.depositReturnedToBorrower ?? 'Deposit dikembalikan ke peminjam.',
        ),
        label: Text(
            l10n?.returnDepositToBorrower ?? 'Kembalikan Deposit ke Peminjam'),
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
    SectionTitle(l10n?.adminActions ?? 'Tindakan Admin'),
    const SizedBox(height: RuangBukuSpacing.md),
    SizedBox(width: double.infinity, child: control),
  ];
}
