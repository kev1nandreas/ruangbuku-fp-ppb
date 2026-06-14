import 'package:flutter/material.dart';
import '../../../core/preferences_notifier.dart';
import '../../../core/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListenableBuilder(
        listenable: PreferencesNotifier.instance,
        builder: (context, _) {
          final prefs = PreferencesNotifier.instance;
          
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: RuangBukuSpacing.md),
            children: [
              _buildSectionHeader(context, 'Tampilan & Lokalisasi'),
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: const Text('Tema (Theme)'),
                trailing: DropdownButton<ThemeMode>(
                  value: prefs.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      prefs.setThemeMode(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Default'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Mode'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Mode'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Bahasa (Language)'),
                trailing: DropdownButton<String>(
                  value: prefs.language,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      prefs.setLanguage(newValue);
                      // TODO: Implement actual translation logic when localization-interaction branch is merged.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perubahan bahasa akan aktif setelah fitur localization digabungkan.')),
                      );
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'id',
                      child: Text('Indonesia'),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildSectionHeader(context, 'Pengaturan Notifikasi'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: const Text('Notifikasi Peminjaman'),
                subtitle: const Text('Beri tahu saat ada yang ingin meminjam buku Anda'),
                value: prefs.notifBorrow,
                onChanged: (val) => prefs.setNotifBorrow(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.access_time_outlined),
                title: const Text('Pengingat Deposit (SLA)'),
                subtitle: const Text('Beri tahu sebelum batas waktu deposit 24 jam habis'),
                value: prefs.notifSla,
                onChanged: (val) => prefs.setNotifSla(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.handshake_outlined),
                title: const Text('Pengingat Penyerahan/Pengembalian'),
                subtitle: const Text('Beri tahu batas waktu penyerahan buku'),
                value: prefs.notifHandover,
                onChanged: (val) => prefs.setNotifHandover(val),
              ),
              const Divider(),
              _buildSectionHeader(context, 'Privasi & Preferensi Buku'),
              SwitchListTile(
                secondary: const Icon(Icons.public_outlined),
                title: const Text('Koleksi Publik Secara Default'),
                subtitle: const Text('Buku baru yang ditambahkan otomatis menjadi Koleksi Publik'),
                value: prefs.publicDefault,
                onChanged: (val) => prefs.setPublicDefault(val),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.visibility_off_outlined),
                title: const Text('Sembunyikan Nomor WA'),
                subtitle: const Text('Nomor hanya bisa dilihat setelah pinjaman disetujui'),
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
