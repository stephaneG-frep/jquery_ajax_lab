import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

enum AppThemeMode { system, light, dark }

class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  AppThemeMode _themeMode = AppThemeMode.system;
  double _textScale = 1.0;
  double _codeFontSize = 13.5;
  bool _loaded = false;

  AppThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;
  double get codeFontSize => _codeFontSize;
  bool get isLoaded => _loaded;

  ThemeMode get flutterThemeMode => switch (_themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _themeMode = AppThemeMode.values.asNameMap()[prefs.getString(StorageKeys.settingsTheme)] ??
          AppThemeMode.system;
      _textScale = prefs.getDouble(StorageKeys.settingsTextScale) ?? 1.0;
      _codeFontSize = prefs.getDouble(StorageKeys.settingsCodeSize) ?? 13.5;
      _loaded = true;
      notifyListeners();
    } catch (_) {
      _loaded = true;
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _save();
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale.clamp(0.8, 1.4);
    notifyListeners();
    await _save();
  }

  Future<void> setCodeFontSize(double size) async {
    _codeFontSize = size.clamp(10, 20);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.settingsTheme, _themeMode.name);
      await prefs.setDouble(StorageKeys.settingsTextScale, _textScale);
      await prefs.setDouble(StorageKeys.settingsCodeSize, _codeFontSize);
    } catch (_) {
      // Le stockage peut être indisponible en test : on ignore.
    }
  }
}
