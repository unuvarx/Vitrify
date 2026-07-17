import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../config/app_config.dart';
import 'auth_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  final AuthService _auth = AuthService();

  // Token'lı header hazırla
  Future<Options> _authOptions() async {
    final token = await _auth.getIdToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // Görseli sıkıştır + base64 data URI'ye çevir
  // (Adım 8'de öğrendik: sıkıştırma süreyi 44sn → 13sn düşürüyor!)
  Future<String> _imageToDataUri(File imageFile) async {
    // Sıkıştır: max 1024px, kalite 85
    final compressed = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressed == null) {
      throw Exception('Görsel sıkıştırılamadı.');
    }

    final base64Str = base64Encode(compressed);
    return 'data:image/jpeg;base64,$base64Str';
  }

  // Toplu görsel üretimi başlat
  Future<Map<String, dynamic>> createJob({
    required List<File> images,
    required String scenePrompt,
    required List<String> scenarios,
    required String aspectRatio,
  }) async {
    // Tüm görselleri sıkıştırıp base64'e çevir (paralel)
    final dataUris = await Future.wait(
      images.map((img) => _imageToDataUri(img)),
    );

    final response = await _dio.post(
      '/api/jobs/create',
      data: {
        'scenePrompt': scenePrompt,
        'scenarios': scenarios,
        'aspectRatio': aspectRatio,
        'images': dataUris,
      },
      options: await _authOptions(),
    );

    return response.data;
  }

  // Job durumunu sorgula (SignalR yedeği olarak)
  Future<Map<String, dynamic>> getJobStatus(String jobId) async {
    final response = await _dio.get(
      '/api/jobs/$jobId/status',
      options: await _authOptions(),
    );
    return response.data;
  }

  // Kredi bakiyesi
  Future<int> getCredits() async {
    final response = await _dio.get(
      '/api/credits/balance',
      options: await _authOptions(),
    );
    return response.data['credits'] as int;
  }

  // Satın alma sonrası kredi ekle (RevenueCat client-side onayı ile)
  Future<Map<String, dynamic>> addCredits({
    required int credits,
    required String storeTransactionId,
    required String platform,
  }) async {
    final response = await _dio.post(
      '/api/credits/add',
      data: {
        'storeTransactionId': storeTransactionId,
        'credits': credits,
        'platform': platform,
      },
      options: await _authOptions(),
    );
    return response.data;
  }
}