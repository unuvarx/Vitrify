import 'package:hive_flutter/hive_flutter.dart';
import '../models/theme_settings.dart';

class StorageService {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeKey = 'current_theme';

  // Uygulama açılışında Hive'ı başlat
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_themeBoxName);
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