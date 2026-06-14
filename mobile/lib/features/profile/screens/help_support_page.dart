import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';

/// Static help & support: expandable FAQ entries plus contact shortcuts
/// (email + WhatsApp). No backend required.
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const _supportEmail = 'support@ruangbuku.app';
  static const _supportWhatsApp = '6281234567890';

  // Moved FAQs to build method for l10n access

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
    final l10n = AppLocalizations.of(context);

    final faqs = <(String, String)>[
      (
        l10n?.faq1Q ?? 'Bagaimana cara meminjam buku?',
        l10n?.faq1A ?? 'Buka detail buku yang tersedia, pilih tanggal pinjam, lalu kirim permintaan.',
      ),
      (
        l10n?.faq2Q ?? 'Apa itu deposit?',
        l10n?.faq2A ?? 'Deposit adalah jaminan yang kamu bayarkan saat meminjam.',
      ),
      (
        l10n?.faq3Q ?? 'Bagaimana jika buku rusak saat dikembalikan?',
        l10n?.faq3A ?? 'Pemilik dapat melaporkan kerusakan.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.helpSupport ?? 'Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
        children: [

          Text(l10n?.faqTitle ?? 'Pertanyaan Umum', style: textTheme.titleLarge),
          const SizedBox(height: RuangBukuSpacing.md),
          ...faqs.map((faq) => Card(
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
          Text(l10n?.contactSupport ?? 'Hubungi Kami', style: textTheme.titleLarge),
          const SizedBox(height: RuangBukuSpacing.md),
          ListTile(
            leading: Icon(Icons.email_outlined,
                color: Theme.of(context).colorScheme.primary),
            title: Text(l10n?.emailContact ?? 'Email'),
            subtitle: const Text(_supportEmail),
            onTap: () => _launch(context, Uri(
              scheme: 'mailto',
              path: _supportEmail,
              query: 'subject=Bantuan RuangBuku',
            )),
          ),
          ListTile(
            leading: Icon(Icons.chat_outlined,
                color: Theme.of(context).colorScheme.primary),
            title: Text(l10n?.whatsappContact ?? 'WhatsApp'),
            subtitle: const Text('Chat tim dukungan'),
            onTap: () => _launch(context,
                Uri.parse('https://wa.me/$_supportWhatsApp')),
          ),
        ],
      ),
    );
  }
}
