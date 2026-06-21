import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/domain/auth_notifier.dart';
import '../widgets/borrow_progress_timeline.dart';
import '../widgets/borrowing_detail_sections.dart';
import '../../../l10n/app_localizations.dart';

class BorrowingDetailPage extends StatelessWidget {
  final String borrowingId;

  const BorrowingDetailPage({super.key, required this.borrowingId});

  /// Looks up the borrow in both the borrower-side and owner-side lists.
  BorrowModel? _findBorrow(RuangBukuState state) {
    for (final list in [state.borrowings, state.ownerBorrowings]) {
      final index = list.indexWhere((b) => b.id == borrowingId);
      if (index != -1) return list[index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final l10n = AppLocalizations.of(context);
        final b = _findBorrow(state);

        if (b == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n?.borrowingDetailsTitle ?? 'Detail Peminjaman'),
            ),
            body: Center(
              child: Text(
                l10n?.transactionNotFound ?? 'Transaksi tidak ditemukan',
              ),
            ),
          );
        }

        // The viewer is the lender whenever they are not the borrower.
        final currentUserId = AuthNotifier.instance.user?.id;
        final isLender = currentUserId != null && b.borrowerId != currentUserId;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.borrowingDetailsTitle ?? 'Detail Peminjaman',
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
                BorrowBookInfoCard(borrow: b),
                const SizedBox(height: RuangBukuSpacing.xl),

                _SectionTitle(l10n?.transactionInfo ?? 'Informasi Transaksi'),
                const SizedBox(height: RuangBukuSpacing.md),
                BorrowTransactionInfoCard(borrow: b, isLender: isLender),

                const SizedBox(height: RuangBukuSpacing.xl),
                _SectionTitle(l10n?.borrowingProgress ?? 'Progres Peminjaman'),
                const SizedBox(height: RuangBukuSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(RuangBukuSpacing.md),
                  child: BorrowProgressTimeline(status: b.status, borrow: b),
                ),

                if (b.damageReport != null) ...[
                  const SizedBox(height: RuangBukuSpacing.xl),
                  _SectionTitle(l10n?.damageReportLabel ?? 'Laporan Kerusakan'),
                  const SizedBox(height: RuangBukuSpacing.md),
                  BorrowDamageReportCard(borrow: b),
                ],

                ...buildContactActions(context, b),
                ...buildBorrowerActions(context, b),
                ...buildOwnerActions(context, b),
                ...buildAdminActions(context, b),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Bold section heading used between cards on this page.
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

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
