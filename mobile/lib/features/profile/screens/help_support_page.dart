import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';

/// Static help & support: expandable FAQ entries plus contact shortcuts
/// (email + WhatsApp). No backend required.
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _supportEmail = 'support@ruangbuku.app';
  static const _supportWhatsApp = '6281234567890';

  static const _faqs = <(String, String)>[
    (
      'Bagaimana cara meminjam buku?',
      'Buka detail buku yang tersedia, pilih tanggal pinjam, lalu kirim '
          'permintaan. Pemilik akan menyetujui dan kamu mengunggah bukti '
          'deposit untuk diverifikasi admin.',
    ),
    (
      'Apa itu deposit?',
      'Deposit adalah jaminan yang kamu bayarkan saat meminjam. Deposit '
          'dikembalikan setelah buku dikembalikan dalam kondisi baik.',
    ),
    (
      'Bagaimana menambahkan buku saya?',
      'Masuk ke menu koleksi, tekan tambah buku, isi ISBN (atau scan), '
          'unggah foto sampul, lalu pilih apakah buku tersedia untuk dipinjam.',
    ),
    (
      'Bagaimana jika buku rusak saat dikembalikan?',
      'Pemilik dapat melaporkan kerusakan. Admin akan meninjau bukti dan '
          'memutuskan pembagian deposit antara peminjam dan pemilik.',
    ),
  ];

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi tujuan.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        children: [
          Text('Pertanyaan Umum', style: textTheme.titleLarge),
          const SizedBox(height: RuangBukuSpacing.md),
          ..._faqs.map((faq) => Card(
                margin: const EdgeInsets.only(bottom: RuangBukuSpacing.sm),
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: RuangBukuRadius.borderRadiusMd,
                ),
                child: ExpansionTile(
                  shape: const Border(),
                  title: Text(faq.$1,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(
                      RuangBukuSpacing.lg, 0, RuangBukuSpacing.lg,
                      RuangBukuSpacing.lg),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(faq.$2, style: textTheme.bodyMedium),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: RuangBukuSpacing.xl),
          Text('Hubungi Kami', style: textTheme.titleLarge),
          const SizedBox(height: RuangBukuSpacing.md),
          ListTile(
            leading: const Icon(Icons.email_outlined,
                color: RuangBukuColors.primary),
            title: const Text('Email'),
            subtitle: const Text(_supportEmail),
            onTap: () => _launch(context, Uri(
              scheme: 'mailto',
              path: _supportEmail,
              query: 'subject=Bantuan RuangBuku',
            )),
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined,
                color: RuangBukuColors.primary),
            title: const Text('WhatsApp'),
            subtitle: const Text('Chat tim dukungan'),
            onTap: () => _launch(context,
                Uri.parse('https://wa.me/$_supportWhatsApp')),
          ),
        ],
      ),
    );
  }
}
