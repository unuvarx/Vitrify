import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import '../config/app_config.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  // Mevcut kullanıcı
  User? get currentUser => _auth.currentUser;

  // Kayıt ol (email + şifre)
  Future<User?> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // Giriş yap (email + şifre)
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firebase token'ını al (backend'e göndereceğiz)
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  // Cihaza özel benzersiz kimlik üret (cihaz kilidi için)
  Future<String> getDeviceId() async {
    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      // identifierForVendor: cihaza özel, uygulama silinmedikçe sabit
      return iosInfo.identifierForVendor ?? 'unknown-ios';
    } else if (Platform.isAndroid) {
      // NOT: device_info_plus'ın androidInfo.id alanı Build.ID'yi (işletim
      // sistemi build numarası) döndürür — bu cihaza özel DEĞİL, aynı Android
      // sürümünü çalıştıran her cihazda aynı çıkar. Cihaza özel kimlik için
      // Settings.Secure.ANDROID_ID okuyan android_id paketini kullanıyoruz.
      final androidId = await const AndroidId().getId();
      return androidId ?? 'unknown-android';
    }

    return 'unknown-device';
  }

  // Platform adı
  String getPlatform() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  // Backend'e giriş bildir (cihaz kilidi + kredi kontrolü)
  Future<Map<String, dynamic>> loginToBackend() async {
    final token = await getIdToken();
    if (token == null) throw Exception('Token alınamadı.');

    final deviceId = await getDeviceId();
    final platform = getPlatform();

    final response = await _dio.post(
      '/api/auth/login',
      data: {
        'deviceId': deviceId,
        'devicePlatform': platform,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response.data;
  }
}