import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/theme_settings.dart';

class StorageService {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeKey = 'current_theme';

  static const String _appSettingsBoxName = 'app_settings';
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _themeModeKey = 'theme_mode';

  // Uygulama açılışında Hive'ı başlat
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_themeBoxName);
    await Hive.openBox(_appSettingsBoxName);
  }

  // İlk açılış tanıtımı daha önce gösterildi mi?
  bool hasSeenOnboarding() {
    final box = Hive.box(_appSettingsBoxName);
    return box.get(_onboardingSeenKey, defaultValue: false) as bool;
  }

  Future<void> setOnboardingSeen() async {
    final box = Hive.box(_appSettingsBoxName);
    await box.put(_onboardingSeenKey, true);
  }

  // Kullanıcının açık/koyu/sistem tema tercihi
  ThemeMode getThemeMode() {
    final box = Hive.box(_appSettingsBoxName);
    final value = box.get(_themeModeKey, defaultValue: 'system') as String;
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = Hive.box(_appSettingsBoxName);
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await box.put(_themeModeKey, value);
  }

  // Tema ayarlarını kaydet
  Future<void> saveThemeSettings(ThemeSettings settings) async {
    final box = Hive.box(_themeBoxName);
    await box.put(_themeKey, settings.toMap());
  }

  // Tema ayarlarını oku
  ThemeSettings getThemeSettings() {
    final box = Hive.box(_themeBoxName);
    final data = box.get(_themeKey);

    if (data == null) {
      // İlk açılış - boş ayarlar döndür
      return ThemeSettings();
    }

    return ThemeSettings.fromMap(data as Map);
  }

  // Tema ayarlarını sil (sıfırla)
  Future<void> clearThemeSettings() async {
    final box = Hive.box(_themeBoxName);
    await box.delete(_themeKey);
  }

  // Ayar var mı? (ilk kullanım kontrolü)
  bool hasThemeSettings() {
    final box = Hive.box(_themeBoxName);
    return box.containsKey(_themeKey);
  }
}