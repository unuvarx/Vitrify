import 'package:signalr_netcore/signalr_client.dart';
import '../config/app_config.dart';

class SignalRService {
  HubConnection? _connection;

  Future<void> _ensureConnected() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      return;
    }

    // Eski bağlantıyı temizle
    await disconnect();

    _connection = HubConnectionBuilder()
        .withUrl(AppConfig.signalRHubUrl)
        .withAutomaticReconnect()
        .build();

    await _connection!.start();
  }

  // Görsel hazır callback (bağlantıdan ÖNCE tanımlanmalı)
  void onImageReady(void Function(Map<String, dynamic>) callback) {
    _connection?.on('ImageReady', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = Map<String, dynamic>.from(arguments[0] as Map);
        callback(data);
      }
    });
  }

  void onImageFailed(void Function(Map<String, dynamic>) callback) {
    _connection?.on('ImageFailed', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = Map<String, dynamic>.from(arguments[0] as Map);
        callback(data);
      }
    });
  }

  // Bağlan + dinlemeye başla (callback'ler dışarıdan set edilir)
  Future<void> connectAndSubscribe(
      String jobId, {
        required void Function(Map<String, dynamic>) onReady,
        required void Function(Map<String, dynamic>) onFailed,
      }) async {
    await _ensureConnected();

    // Callback'leri KAYIT ET (bağlantı kurulduktan sonra)
    onImageReady(onReady);
    onImageFailed(onFailed);

    // Gruba katıl
    await _connection!.invoke('SubscribeToJob', args: [jobId]);
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
    } catch (_) {}
    _connection = null;
  }
}