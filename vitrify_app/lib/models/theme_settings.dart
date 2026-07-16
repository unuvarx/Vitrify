class ThemeSettings {
  String scenePrompt;      // Ana mekan promptu
  List<String> scenarios;  // Senaryolar listesi
  String aspectRatio;      // "1:1", "4:5", "9:16", "16:9"

  ThemeSettings({
    this.scenePrompt = '',
    List<String>? scenarios,
    this.aspectRatio = '1:1',
  }) : scenarios = scenarios ?? [''];

  // Hive'a kaydetmek için Map'e çevir
  Map<String, dynamic> toMap() {
    return {
      'scenePrompt': scenePrompt,
      'scenarios': scenarios,
      'aspectRatio': aspectRatio,
    };
  }

  // Hive'dan okurken Map'ten oluştur
  factory ThemeSettings.fromMap(Map<dynamic, dynamic> map) {
    return ThemeSettings(
      scenePrompt: map['scenePrompt'] ?? '',
      scenarios: List<String>.from(map['scenarios'] ?? ['']),
      aspectRatio: map['aspectRatio'] ?? '1:1',
    );
  }

  // Geçerli mi? (üretim için hazır mı?)
  bool get isValid {
    return scenePrompt.trim().isNotEmpty &&
        scenarios.any((s) => s.trim().isNotEmpty);
  }

  // Boş olmayan senaryolar
  List<String> get validScenarios {
    return scenarios.where((s) => s.trim().isNotEmpty).toList();
  }
}