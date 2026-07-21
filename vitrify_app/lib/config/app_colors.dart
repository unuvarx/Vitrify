import 'package:flutter/material.dart';

// Açık/koyu temaya göre değişen renkler. Fonksiyon olmalarının sebebi:
// aynı isim (örn. AppColors.geceSiyahi) hem koyu hem açık modda doğru rengi
// döndürsün — ekranlar context'in brightness'ına göre otomatik uyum sağlar.
class AppColors {
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Ana arka plan
  static Color geceSiyahi(BuildContext context) =>
      _isDark(context) ? darkBackground : lightBackground;

  // Birincil metin
  static Color safBeyaz(BuildContext context) =>
      _isDark(context) ? darkTextPrimary : lightTextPrimary;

  // Butonlar, aksiyonlar (marka rengi — her iki modda da aynı aile)
  static Color vitrifyMavisi(BuildContext context) =>
      _isDark(context) ? darkPrimary : lightPrimary;

  // Kart arka planları
  static Color derinGri(BuildContext context) =>
      _isDark(context) ? darkSurface : lightSurface;

  // İkincil metin
  static Color acikGri(BuildContext context) =>
      _isDark(context) ? darkTextSecondary : lightTextSecondary;

  // Hata mesajları
  static Color hataKirmizi(BuildContext context) =>
      _isDark(context) ? darkError : lightError;

  // Başarı mesajları
  static Color basariYesili(BuildContext context) =>
      _isDark(context) ? darkSuccess : lightSuccess;

  // Kart kenarlığı — arka plan/kart kontrastı düşük kaldığı yerlerde (örn.
  // koyu modda) karta ince bir sınır çizerek ayrımı belirginleştirir
  static Color cardBorder(BuildContext context) =>
      _isDark(context) ? darkBorder : lightBorder;

  // Ham değerler — sadece ThemeData'yı (main.dart) oluştururken kullanılır,
  // ekranlarda doğrudan kullanılmaz (yukarıdaki context'e duyarlı metotları kullanın)
  //
  // "Modern SaaS / indigo" yönü: nötr gri yerine her tonun içine hafif
  // mor/lacivert bir alt ton karıştırılıyor (Linear/Notion tarzı) — arka plan
  // ile kart arasında da bilinçli olarak büyük kontrast var.
  static const Color darkBackground = Color(0xFF0A0A12);
  static const Color darkSurface = Color(0xFF1C1B29);
  static const Color darkBorder = Color(0xFF322F45);
  static const Color darkPrimary = Color(0xFF7C6CFF);
  static const Color darkTextPrimary = Color(0xFFF1F0F7);
  static const Color darkTextSecondary = Color(0xFF9D9BB5);
  static const Color darkError = Color(0xFFFF6B81);
  static const Color darkSuccess = Color(0xFF4CD9A0);

  static const Color lightBackground = Color(0xFFF5F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE1DEF5);
  static const Color lightPrimary = Color(0xFF6C5CE0);
  static const Color lightTextPrimary = Color(0xFF17151F);
  static const Color lightTextSecondary = Color(0xFF6E6B85);
  static const Color lightError = Color(0xFFE0475F);
  static const Color lightSuccess = Color(0xFF22A874);
}
