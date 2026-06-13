import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.settings ?? 'Settings',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: RuangBukuState.instance,
        builder: (context, _) {
          final state = RuangBukuState.instance;
          final currentLang = state.currentLocale.languageCode;

          return ListView(
            padding: const EdgeInsets.all(RuangBukuSpacing.marginMobile),
            children: [
              Text(
                l10n?.language ?? 'Language',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: RuangBukuSpacing.md),
              RadioListTile<String>(
                title: Text(l10n?.indonesia ?? 'Indonesia'),
                value: 'id',
                groupValue: currentLang,
                onChanged: (value) {
                  if (value != null) {
                    state.setLocale(Locale(value));
                  }
                },
                contentPadding: EdgeInsets.zero,
                activeColor: RuangBukuColors.primary,
              ),
              RadioListTile<String>(
                title: Text(l10n?.english ?? 'English'),
                value: 'en',
                groupValue: currentLang,
                onChanged: (value) {
                  if (value != null) {
                    state.setLocale(Locale(value));
                  }
                },
                contentPadding: EdgeInsets.zero,
                activeColor: RuangBukuColors.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}
