import 'dart:io';

class AppConfig {
  // Backend API adresi (platform bazlı)
  static String get apiBaseUrl {
    if (Platform.isAndroid) {
      // Android Emulator → localhost yerine 10.0.2.2 kullanır
      return "http://10.0.2.2:5118";
    }
    // iOS Simulator → localhost çalışır
    return "http://localhost:5118";
  }

  static String get signalRHubUrl => "$apiBaseUrl/jobhub";

  static const String firebaseProjectId = "vitrify-c68b0";
}