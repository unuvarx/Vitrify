import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  static const _secureStorage = FlutterSecureStorage();
  static const _deviceIdKey = 'vitrify_device_id';

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

  // Google ile giriş yap
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // kullanıcı iptal etti

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  // Apple ile giriş yap (App Store Guideline 4.8: üçüncü taraf girişi
  // (Google) sunuyorsak, aynı gizlilik standartlarını karşılayan bir
  // alternatif de sunmamız gerekiyor — Apple'ın kendisi bu şartı sağlıyor)
  Future<User?> signInWithApple() async {
    // Firebase'in önerdiği güvenlik deseni: rastgele bir nonce üretip
    // SHA-256 hash'ini Apple'a, ham halini Firebase'e veriyoruz — bu, geri
    // gönderilen kimlik token'ının bu isteğe ait olduğunu doğrular.
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    final result = await _auth.signInWithCredential(oauthCredential);
    return result.user;
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Şifremi unuttum — Firebase'in şifre sıfırlama e-postasını gönderir
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Bildirim izni iste + FCM token'ı al (izin verilmediyse ya da alınamazsa
  // null döner — uygulama push olmadan da çalışabilmeli)
  Future<String?> _getFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[FCM] Bildirim izni reddedildi.');
        return null;
      }

      // iOS'ta APNs cihaz token'ı native tarafta hazır olmadan getToken()
      // çağrılırsa sessizce başarısız olabiliyor (bilinen bir race condition)
      // — hazır olana kadar kısa aralıklarla birkaç kez deniyoruz
      if (Platform.isIOS) {
        String? apnsToken;
        for (var i = 0; i < 6 && apnsToken == null; i++) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
        if (apnsToken == null) {
          debugPrint('[FCM] APNs token zaman aşımına uğradı, getToken() denenmeyecek.');
          return null;
        }
      }

      final token = await messaging.getToken();
      debugPrint('[FCM] Token alındı mı: ${token != null}');
      return token;
    } catch (e) {
      debugPrint('[FCM] Token alınamadı: $e');
      return null;
    }
  }

  // Firebase token'ını al (backend'e göndereceğiz)
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  // Cihaza özel benzersiz kimlik üret (cihaz kilidi için)
  Future<String> getDeviceId() async {
    if (Platform.isIOS) {
      // identifierForVendor uygulama silinip yeniden yüklendiğinde (aynı
      // geliştiriciden başka app kalmamışsa) sıfırlanabiliyor — bu da cihaz
      // kilidini sil-yükle ile atlatılabilir hale getiriyordu. Keychain ise
      // uygulama silinse bile cihazda kalıyor: ilk üretilen ID'yi Keychain'e
      // yazıp bundan sonra hep oradan okuyoruz.
      final cached = await _secureStorage.read(key: _deviceIdKey);
      if (cached != null) return cached;

      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final freshId = iosInfo.identifierForVendor ?? 'unknown-ios';
      await _secureStorage.write(key: _deviceIdKey, value: freshId);
      return freshId;
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
    debugPrint('[FCM] loginToBackend() başladı.');
    final token = await getIdToken();
    if (token == null) throw Exception('Token alınamadı.');

    final deviceId = await getDeviceId();
    final platform = getPlatform();
    debugPrint('[FCM] _getFcmToken() çağrılıyor...');
    final fcmToken = await _getFcmToken();
    debugPrint('[FCM] loginToBackend() gönderiyor, fcmToken null mu: ${fcmToken == null}');

    final response = await _dio.post(
      '/api/auth/login',
      data: {
        'deviceId': deviceId,
        'devicePlatform': platform,
        'fcmToken': ?fcmToken,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return response.data;
  }
}