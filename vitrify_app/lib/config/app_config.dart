class AppConfig {
  // Backend API adresi — Railway'de canlı çalışan production backend
  static String get apiBaseUrl => "https://vitrify-production.up.railway.app";

  static String get signalRHubUrl => "$apiBaseUrl/jobhub";

  static const String firebaseProjectId = "vitrifyfirebase";
}