import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../l10n/app_localizations.dart';

/// Card for a pending borrow request on a book the current user owns, with
/// inline Accept / Reject controls wired to the approve/reject routes.
class IncomingRequestCard extends StatefulWidget {
  const IncomingRequestCard({super.key, required this.borrowing});

  final BorrowModel borrowing;

  @override
  State<IncomingRequestCard> createState() => _IncomingRequestCardState();
}

class _IncomingRequestCardState extends State<IncomingRequestCard> {
  bool _busy = false;

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _respond(bool approve) async {
    final b = widget.borrowing;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await RuangBukuState.instance.respondToBorrowRequest(b.id, approve);
      messenger.showSnackBar(SnackBar(
        content: Text(approve
            ? (l10n?.requestAccepted ?? 'Permintaan diterima.')
            : (l10n?.requestRejected ?? 'Permintaan ditolak.')),
      ));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n?.failed(e.toString()) ?? 'Gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final b = widget.borrowing;

    return Container(
      padding: const EdgeInsets.all(RuangBukuSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: RuangBukuRadius.borderRadiusLg,
        border: Border.all(color: theme.colorScheme.primary),
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
                  cacheWidth: 160,
                  errorBuilder: (_, _, _) => Container(
                    width: 50,
                    height: 75,
                    color: RuangBukuColors.surfaceContainerHigh,
                    child: const Icon(Icons.book, color: RuangBukuColors.outline),
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
                    Text(
                        l10n?.borrowerName(b.borrowerName) ??
                            'Peminjam: ${b.borrowerName}',
                        style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                    Text('${_fmt(b.startDate)} - ${_fmt(b.endDate)}',
                        style: textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
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
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
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
