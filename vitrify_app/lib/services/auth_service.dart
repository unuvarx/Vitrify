import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      // identifierForVendor: cihaza özel, uygulama silinmedikçe sabit
      return iosInfo.identifierForVendor ?? 'unknown-ios';
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      // Android ID: cihaza özel
      return androidInfo.id;
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