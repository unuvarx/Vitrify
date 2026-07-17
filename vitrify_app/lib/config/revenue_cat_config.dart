class RevenueCatConfig {
  // TODO: RevenueCat dashboard > Project Settings > API Keys içindeki
  // public SDK anahtarlarını buraya gir (gizli/secret key DEĞİL).
  static const String iosApiKey = 'REVENUECAT_IOS_API_KEY_BURAYA';
  static const String androidApiKey = 'REVENUECAT_ANDROID_API_KEY_BURAYA';

  // TODO: RevenueCat dashboard'da tanımladığın paketlerin identifier'ını
  // (Offering > Package > Identifier) kaç krediye denk geldiğiyle eşle.
  // Örnek: App Store Connect / Play Console'da "credits_10" adlı ürünü
  // 10 kredilik bir pakete bağladıysan:
  //   'credits_10': 10,
  //   'credits_50': 50,
  static const Map<String, int> packageCredits = {};
}
