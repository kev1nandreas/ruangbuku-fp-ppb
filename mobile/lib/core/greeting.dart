import '../l10n/app_localizations.dart';

/// Time-of-day greeting (localized, Indonesian fallbacks). Shared by the user
/// and admin home headers so the time buckets stay consistent.
String greetingFor(AppLocalizations? l10n, {DateTime? now}) {
  final hour = (now ?? DateTime.now()).hour;
  if (hour < 12) return l10n?.goodMorning ?? 'Good morning,';
  if (hour < 15) return l10n?.goodAfternoonSiang ?? 'Good afternoon,';
  if (hour < 18) return l10n?.goodAfternoonSore ?? 'Good afternoon,';
  return l10n?.goodEvening ?? 'Good evening,';
}
