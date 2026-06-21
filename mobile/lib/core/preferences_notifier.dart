import 'package:flutter/material.dart';
import 'storage/secure_storage.dart';

class PreferencesNotifier extends ChangeNotifier {
  PreferencesNotifier._();
  static final PreferencesNotifier instance = PreferencesNotifier._();

  final _storage = SecureStorage.instance;

  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'id';
  bool _notifBorrow = true;
  bool _notifSla = true;
  bool _notifHandover = true;
  bool _publicDefault = false;
  bool _hideWa = false;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get notifBorrow => _notifBorrow;
  bool get notifSla => _notifSla;
  bool get notifHandover => _notifHandover;
  bool get publicDefault => _publicDefault;
  bool get hideWa => _hideWa;

  Future<void> loadPreferences() async {
    final themeStr = await _storage.getThemeMode();
    if (themeStr == 'light') _themeMode = ThemeMode.light;
    else if (themeStr == 'dark') _themeMode = ThemeMode.dark;
    else _themeMode = ThemeMode.system;

    _language = await _storage.getLanguage() ?? 'id';
    _notifBorrow = (await _storage.getNotifBorrow() ?? 'true') == 'true';
    _notifSla = (await _storage.getNotifSla() ?? 'true') == 'true';
    _notifHandover = (await _storage.getNotifHandover() ?? 'true') == 'true';
    _publicDefault = (await _storage.getPublicDefault() ?? 'false') == 'true';
    _hideWa = (await _storage.getHideWa() ?? 'false') == 'true';

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String val = 'system';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.dark) val = 'dark';
    await _storage.setThemeMode(val);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _storage.setLanguage(lang);
    notifyListeners();
  }

  Future<void> setNotifBorrow(bool val) async {
    _notifBorrow = val;
    await _storage.setNotifBorrow(val.toString());
    notifyListeners();
  }

  Future<void> setNotifSla(bool val) async {
    _notifSla = val;
    await _storage.setNotifSla(val.toString());
    notifyListeners();
  }

  Future<void> setNotifHandover(bool val) async {
    _notifHandover = val;
    await _storage.setNotifHandover(val.toString());
    notifyListeners();
  }

  Future<void> setPublicDefault(bool val) async {
    _publicDefault = val;
    await _storage.setPublicDefault(val.toString());
    notifyListeners();
  }

  Future<void> setHideWa(bool val) async {
    _hideWa = val;
    await _storage.setHideWa(val.toString());
    notifyListeners();
  }
}
