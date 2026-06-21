import 'package:flutter/material.dart';
import '../../../core/preferences_notifier.dart';
import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settings ?? 'Pengaturan'),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          PreferencesNotifier.instance,
          RuangBukuState.instance,
        ]),
        builder: (context, _) {
          final prefs = PreferencesNotifier.instance;
          final state = RuangBukuState.instance;
          final currentLang = state.currentLocale.languageCode;
          
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.md),
            children: [
              _buildSectionHeader(context, l10n?.appearanceLoc ?? 'Tampilan & Lokalisasi'),
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: Text(l10n?.themeMode ?? 'Tema (Theme)'),
                trailing: DropdownButton<ThemeMode>(
                  value: prefs.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      prefs.setThemeMode(newValue);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n?.systemDefault ?? 'System Default'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n?.lightMode ?? 'Light Mode'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n?.darkMode ?? 'Dark Mode'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n?.language ?? 'Bahasa (Language)'),
                trailing: DropdownButton<String>(
                  value: currentLang,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      state.setLocale(Locale(newValue));
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'id',
                      child: Text(l10n?.indonesia ?? 'Indonesia'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l10n?.english ?? 'English'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildSectionHeader(context, l10n?.notificationSettings ?? 'Pengaturan Notifikasi'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: Text(l10n?.notifBorrow ?? 'Notifikasi Peminjaman'),
                subtitle: Text(l10n?.notifBorrowDesc ?? 'Beri tahu saat ada yang ingin meminjam buku Anda'),
                value: prefs.notifBorrow,
                onChanged: (val) => prefs.setNotifBorrow(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.access_time_outlined),
                title: Text(l10n?.notifSla ?? 'Pengingat Deposit (SLA)'),
                subtitle: Text(l10n?.notifSlaDesc ?? 'Beri tahu sebelum batas waktu deposit 24 jam habis'),
                value: prefs.notifSla,
                onChanged: (val) => prefs.setNotifSla(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.handshake_outlined),
                title: Text(l10n?.notifReturn ?? 'Pengingat Penyerahan/Pengembalian'),
                subtitle: Text(l10n?.notifReturnDesc ?? 'Beri tahu batas waktu penyerahan buku'),
                value: prefs.notifHandover,
                onChanged: (val) => prefs.setNotifHandover(val),
              ),
              const Divider(),
              _buildSectionHeader(context, l10n?.privacyPref ?? 'Privasi & Preferensi Buku'),
              SwitchListTile(
                secondary: const Icon(Icons.public_outlined),
                title: Text(l10n?.publicDefault ?? 'Koleksi Publik Secara Default'),
                subtitle: Text(l10n?.publicDefaultDesc ?? 'Buku baru yang ditambahkan otomatis menjadi Koleksi Publik'),
                value: prefs.publicDefault,
                onChanged: (val) => prefs.setPublicDefault(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.visibility_off_outlined),
                title: Text(l10n?.hideWa ?? 'Sembunyikan Nomor WA'),
                subtitle: Text(l10n?.hideWaDesc ?? 'Nomor hanya bisa dilihat setelah pinjaman disetujui'),
                value: prefs.hideWa,
                onChanged: (val) => prefs.setHideWa(val),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: RuangBukuSpacing.marginMobile,
        vertical: RuangBukuSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
