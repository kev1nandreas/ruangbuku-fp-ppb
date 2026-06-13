import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../data/models/borrow_model.dart';

/// Vertical lifecycle timeline for a borrowing transaction.
/// Renders the canonical happy-path steps with completed/current/pending
/// styling derived from the borrow's current [BorrowStatus]. Terminal
/// rejection/cancellation is surfaced as a distinct error step.
///
/// When [borrow] is provided, each step that already happened shows the
/// backend timestamp recorded at that transition.
class BorrowProgressTimeline extends StatelessWidget {
  const BorrowProgressTimeline({super.key, required this.status, this.borrow});

  final BorrowStatus status;
  final BorrowModel? borrow;

  /// Timestamp recorded for a given step, or null if not reached / unavailable.
  DateTime? _timeFor(BorrowStatus step) {
    final b = borrow;
    if (b == null) return null;
    switch (step) {
      case BorrowStatus.requested:
        return b.createdAt;
      case BorrowStatus.waitingDeposit:
        return b.verifiedAt;
      case BorrowStatus.depositVerified:
        return b.depositReceivedAt;
      case BorrowStatus.bookReceived:
        return b.handedOverAt;
      case BorrowStatus.returnedGood:
        return b.returnedAt;
      case BorrowStatus.completed:
        return b.depositReturnedAt;
      // depositUploaded has no dedicated backend timestamp.
      default:
        return null;
    }
  }

  /// e.g. "13 Jun 2026, 14:05".
  static String _fmt(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final local = d.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year}, $hh:$mm';
  }

  /// Canonical happy-path order. Index used to compute completed vs pending.
  static const List<BorrowStatus> _flow = [
    BorrowStatus.requested,
    BorrowStatus.waitingDeposit,
    BorrowStatus.depositUploaded,
    BorrowStatus.depositVerified,
    BorrowStatus.bookReceived,
    BorrowStatus.returnedGood,
    BorrowStatus.completed,
  ];

  static const Map<BorrowStatus, String> _labels = {
    BorrowStatus.requested: 'Permintaan Dikirim',
    BorrowStatus.waitingDeposit: 'Disetujui — Menunggu Deposit',
    BorrowStatus.depositUploaded: 'Bukti Deposit Diunggah',
    BorrowStatus.depositVerified: 'Deposit Terverifikasi',
    BorrowStatus.bookReceived: 'Buku Diterima Peminjam',
    BorrowStatus.returnedGood: 'Buku Dikembalikan',
    BorrowStatus.completed: 'Transaksi Selesai',
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Cancelled/rejected: short circuit to a single error step trail.
    if (status == BorrowStatus.cancelled) {
      return _CancelledTrail(textTheme: textTheme);
    }

    // Damaged return diverges from returnedGood but sits at the same stage.
    final isDamaged = status == BorrowStatus.returnedDamaged;
    final currentIndex = isDamaged
        ? _flow.indexOf(BorrowStatus.returnedGood)
        : _flow.indexOf(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _flow.length; i++)
          _TimelineStep(
            label: (isDamaged && _flow[i] == BorrowStatus.returnedGood)
                ? 'Buku Dikembalikan (Rusak)'
                : _labels[_flow[i]]!,
            timestamp: _timeFor(_flow[i]),
            isFirst: i == 0,
            isLast: i == _flow.length - 1,
            state: _stateFor(i, currentIndex),
            isError: isDamaged && _flow[i] == BorrowStatus.returnedGood,
            textTheme: textTheme,
          ),
      ],
    );
  }

  _StepState _stateFor(int index, int currentIndex) {
    if (index < currentIndex) return _StepState.completed;
    if (index == currentIndex) return _StepState.current;
    return _StepState.pending;
  }
}

enum _StepState { completed, current, pending }

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.timestamp,
    required this.isFirst,
    required this.isLast,
    required this.state,
    required this.isError,
    required this.textTheme,
  });

  final String label;
  final DateTime? timestamp;
  final bool isFirst;
  final bool isLast;
  final _StepState state;
  final bool isError;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final Color dotColor = isError
        ? RuangBukuColors.error
        : switch (state) {
            _StepState.completed => Colors.green,
            _StepState.current => RuangBukuColors.primary,
            _StepState.pending => RuangBukuColors.outlineVariant,
          };

    final Color lineColor = state == _StepState.pending
        ? RuangBukuColors.outlineVariant
        : Colors.green;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connector column: dot + line.
          Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    color: state == _StepState.pending
                        ? Colors.transparent
                        : dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  child: Icon(
                    state == _StepState.completed
                        ? Icons.check
                        : (isError ? Icons.priority_high : Icons.circle),
                    size: state == _StepState.completed ? 14 : 8,
                    color: state == _StepState.pending
                        ? Colors.transparent
                        : Colors.white,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: lineColor),
                ),
            ],
          ),
          const SizedBox(width: RuangBukuSpacing.md),
          // Label + timestamp.
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 2,
                bottom: isLast ? 0 : RuangBukuSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: state == _StepState.pending
                          ? FontWeight.w400
                          : FontWeight.w600,
                      color: state == _StepState.pending
                          ? RuangBukuColors.textSecondary
                          : (isError
                              ? RuangBukuColors.error
                              : RuangBukuColors.textPrimary),
                    ),
                  ),
                  if (timestamp != null && state != _StepState.pending) ...[
                    const SizedBox(height: 2),
                    Text(
                      BorrowProgressTimeline._fmt(timestamp!),
                      style: textTheme.bodySmall?.copyWith(
                        color: RuangBukuColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledTrail extends StatelessWidget {
  const _CancelledTrail({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: RuangBukuColors.error,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 14, color: Colors.white),
        ),
        const SizedBox(width: RuangBukuSpacing.md),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            'Peminjaman Dibatalkan / Ditolak',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: RuangBukuColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
