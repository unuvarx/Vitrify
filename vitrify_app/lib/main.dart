import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrify_app/screens/main_screen.dart';
import 'config/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'services/purchase_service.dart';
import 'services/storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive'ı başlat (yerel depolama)
  await StorageService.init();

  // RevenueCat'i başlat (henüz yapılandırılmadıysa sessizce geç —
  // uygulamanın geri kalanı RevenueCat olmadan da çalışabilmeli)
  try {
    await PurchaseService().init();
  } catch (_) {}

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
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

// Giriş yapılmışsa MainScreen, yapılmamışsa LoginScreen gösterir
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.geceSiyahi,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.vitrifyMavisi,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          // RevenueCat kullanıcısını bu Firebase hesabına bağla (fire-and-forget)
          PurchaseService().identify(snapshot.data!.uid);
          return const MainScreen();
        }

        return const LoginScreen();
      },
    );
  }
}