import 'package:flutter/material.dart';
import 'package:vitrify_app/screens/main_screen.dart';
import 'config/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/storage_service.dart';
import 'screens/theme_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive'ı başlat (yerel depolama)
  await StorageService.init();

  runApp(const VitrifyApp());
}

class VitrifyApp extends StatelessWidget {
  const VitrifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitrify',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const MainScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.geceSiyahi,
      primaryColor: AppColors.vitrifyMavisi,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.vitrifyMavisi,
        surface: AppColors.derinGri,
        onPrimary: AppColors.safBeyaz,
        onSurface: AppColors.safBeyaz,
      ),

      // Kart teması
      cardTheme: CardThemeData(
        color: AppColors.derinGri,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Buton teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.vitrifyMavisi,
          foregroundColor: AppColors.safBeyaz,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Metin alanı teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.derinGri,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Geçici ana ekran - Adım 15+ ile gerçek ekranlar gelecek
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 64,
              color: AppColors.vitrifyMavisi,
            ),
            const SizedBox(height: 24),
            const Text(
              'Vitrify',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.safBeyaz,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yapay zeka ürün fotoğrafçılığı',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.acikGri,
              ),
            ),
          ],
        ),
      ),
    );
  }
}