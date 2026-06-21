import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../notifications/domain/notification_notifier.dart';

/// Admin-only dialog to broadcast an announcement to every user. Manages its
/// own title/body controllers and in-flight state.
Future<void> showBroadcastDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const _BroadcastDialog(),
  );
}

class _BroadcastDialog extends StatefulWidget {
  const _BroadcastDialog();

  @override
  State<_BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends State<_BroadcastDialog> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _isLoading = true);
    try {
      await NotificationNotifier.instance
          .sendBroadcast(_titleCtrl.text, _bodyCtrl.text);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Pengumuman berhasil dikirim')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kirim Pengumuman'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Pesan ini akan dikirim ke seluruh pengguna aplikasi.'),
            const SizedBox(height: RuangBukuSpacing.md),
            TextField(
              controller: _titleCtrl,
              decoration:
                  const InputDecoration(labelText: 'Judul Pengumuman'),
            ),
            const SizedBox(height: RuangBukuSpacing.md),
            TextField(
              controller: _bodyCtrl,
              decoration: const InputDecoration(labelText: 'Isi Pesan'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _send,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Kirim'),
        ),
      ],
    );
  }
}
