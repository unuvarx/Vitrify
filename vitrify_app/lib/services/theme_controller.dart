import 'package:flutter/material.dart';
import 'storage_service.dart';

// Uygulama genelinde tek örnek (singleton) — MaterialApp bunu dinleyip
// temayı anında değiştirir, Profil'deki seçici de bunu günceller.
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);
  final _storage = StorageService();

  void loadSaved() {
    mode.value = _storage.getThemeMode();
  }

  Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;
    await _storage.setThemeMode(newMode);
  }
}
