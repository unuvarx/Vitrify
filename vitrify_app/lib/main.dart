import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrify_app/screens/main_screen.dart';
import 'config/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/auth_service.dart';
import 'services/purchase_service.dart';
import 'services/storage_service.dart';
import 'services/theme_controller.dart';
import 'widgets/app_alert.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive'ı başlat (yerel depolama)
  await StorageService.init();

  // Kaydedilmiş tema tercihini (açık/koyu/sistem) yükle
  ThemeController.instance.loadSaved();

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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Vitrify',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: mode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingGate(),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? AppColors.darkTextPrimary : Colors.white,
        secondary: primary,
        onSecondary: isDark ? AppColors.darkTextPrimary : Colors.white,
        surface: surface,
        onSurface: textPrimary,
        error: isDark ? AppColors.darkError : AppColors.lightError,
        onError: Colors.white,
      ),

      // Kart teması
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // AppBar teması — Material 3 varsayılanı, içerik altından kaydırılınca
      // AppBar'a otomatik bir "tint" (renk karışımı) uyguluyor; bunu kapatıp
      // AppBar'ın rengini her zaman sabit tutuyoruz (griye dönmesin diye)
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),

      // Buton teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Metin alanı teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// İlk açılışta bir kez tanıtım akışını gösterir, sonra AuthGate'e devreder
class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key});

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  final _storage = StorageService();
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _showOnboarding = !_storage.hasSeenOnboarding();
  }

  void _finishOnboarding() {
    _storage.setOnboardingSeen();
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onFinished: _finishOnboarding);
    }
    return const AuthGate();
  }
}

// Giriş yapılmışsa MainScreen, yapılmamışsa LoginScreen gösterir
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();

  // Hangi uid için backend login'in (kullanıcı satırını oluşturup kredi
  // veren /api/auth/login çağrısı) tamamlandığını izler — bu olmadan
  // MainScreen'i gösterirsek ProfileScreen/CreateScreen kredi sorgusu
  // henüz oluşturulmamış kullanıcı için 0 döner (Firebase auth state
  // değişikliği, backend login'den önce/eşzamanlı tetiklenir)
  String? _readyForUid;
  String? _pendingUid;

  Future<void> _ensureBackendLogin(String uid) async {
    if (_pendingUid == uid) return;
    _pendingUid = uid;
    try {
      await _authService.loginToBackend();
    } catch (e) {
      // Geçici olarak hatayı görünür yapıyoruz — sessizce yutulursa kullanıcı
      // satırı hiç oluşmaz ve kredi her zaman 0 görünür, sebebi anlaşılmaz.
      if (mounted) {
        // ignore: use_build_context_synchronously
        AppAlert.show(context, 'Backend login hatası: $e');
      }
    }
    if (!mounted) return;
    setState(() => _readyForUid = uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingScaffold(context);
        }

        final user = snapshot.data;
        if (user == null) {
          _readyForUid = null;
          _pendingUid = null;
          return const LoginScreen();
        }

        if (_readyForUid != user.uid) {
          _ensureBackendLogin(user.uid);
          return _loadingScaffold(context);
        }

        // RevenueCat kullanıcısını bu Firebase hesabına bağla (fire-and-forget)
        PurchaseService().identify(user.uid);
        return const MainScreen();
      },
    );
  }

  Widget _loadingScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.geceSiyahi(context),
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.vitrifyMavisi(context),
        ),
      ),
    );
  }
}