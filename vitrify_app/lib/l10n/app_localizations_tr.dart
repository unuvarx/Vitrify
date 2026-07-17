// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String genericErrorMessage(String error) {
    return 'Hata: $error';
  }

  @override
  String get loginEmailPasswordRequired => 'E-posta ve şifre gerekli.';

  @override
  String get loginEmailHint => 'E-posta';

  @override
  String get loginPasswordHint => 'Şifre';

  @override
  String get loginSignUpButton => 'Kayıt Ol';

  @override
  String get loginSignInButton => 'Giriş Yap';

  @override
  String get loginSwitchToSignIn => 'Zaten hesabın var mı? Giriş yap';

  @override
  String get loginSwitchToSignUp => 'Hesabın yok mu? Kayıt ol';

  @override
  String loginCreditsLabel(int credits) {
    return 'Kredi: $credits';
  }

  @override
  String get navTheme => 'Tema';

  @override
  String get navCreate => 'Oluştur';

  @override
  String get navGallery => 'Galeri';

  @override
  String get navProfile => 'Profil';

  @override
  String get themeAppBarTitle => 'Tema';

  @override
  String get themeSceneTitle => 'Mekan';

  @override
  String get themeSceneSubtitle =>
      'Ürünlerinizin sergileneceği ortamı tanımlayın';

  @override
  String get themeSceneHint =>
      'Örn: Saat 09:00 civarı, güneşin denizin ve kumsalın hoş göründüğü, etrafında adaların olduğu bir ortam';

  @override
  String get themeScenariosTitle => 'Senaryolar';

  @override
  String get themeScenariosSubtitle =>
      'Her senaryo için ayrı bir görsel üretilir';

  @override
  String themeScenarioHint(int index) {
    return 'Senaryo $index — Örn: bir kadının koluna takılı şekilde';
  }

  @override
  String get themeAspectRatioTitle => 'Görsel Oranı';

  @override
  String get themeAspectRatioSubtitle => 'Üretilecek görsellerin en-boy oranı';

  @override
  String get themeScenePromptRequired => 'Mekan açıklaması gerekli.';

  @override
  String get themeScenarioRequired => 'En az bir senaryo gerekli.';

  @override
  String get themeSaved => 'Tema kaydedildi ✓';

  @override
  String get themeSaveButton => 'Kaydet';

  @override
  String get themeSavedButton => 'Kaydedildi';

  @override
  String get createAppBarTitle => 'Oluştur';

  @override
  String get createFillThemeFirst => 'Önce Tema sayfasını doldurun.';

  @override
  String get createSelectAtLeastOneImage => 'En az bir ürün görseli seçin.';

  @override
  String createInsufficientCredits(int required, int available) {
    return 'Yetersiz kredi. Gerekli: $required, Mevcut: $available';
  }

  @override
  String createSomeFailed(int count) {
    return '$count görsel başarısız oldu.';
  }

  @override
  String get createTimeout => 'İşlem uzun sürdü. Lütfen tekrar deneyin.';

  @override
  String get createProductImagesTitle => 'Ürün Görselleri';

  @override
  String get createSelectImages => 'Görsel Seç';

  @override
  String createImagesSelected(int count) {
    return '$count görsel seçildi';
  }

  @override
  String get createSubmitting => 'Gönderiliyor...';

  @override
  String get createGenerateButton => 'Oluştur';

  @override
  String get createGenerating => 'Üretiliyor...';

  @override
  String get createCompleted => 'Tamamlandı 🎉';

  @override
  String get createGeneratedImagesTitle => 'Üretilen Görseller';

  @override
  String get galleryAppBarTitle => 'Galeri';

  @override
  String get galleryDeleteTitle => 'Görseli sil';

  @override
  String get galleryDeleteContent =>
      'Bu görsel cihazınızdan kalıcı olarak silinecek.';

  @override
  String get galleryCancel => 'Vazgeç';

  @override
  String get galleryDelete => 'Sil';

  @override
  String get gallerySavedToDevice => 'Görsel cihaz galerisine kaydedildi.';

  @override
  String get galleryPermissionDenied => 'Galeri izni verilmedi.';

  @override
  String get galleryEmpty => 'Henüz üretilmiş görsel yok.';

  @override
  String get profileAppBarTitle => 'Profil';

  @override
  String get profileCreditsRemaining => 'Kalan Kredi';

  @override
  String get profileBuyCreditsTitle => 'Kredi Satın Al';

  @override
  String get profileBuyCreditsSubtitle =>
      'Daha fazla görsel üretmek için kredi ekleyin';

  @override
  String get profileNoPackages => 'Şu an satın alınabilir paket yok.';

  @override
  String get profilePackagesLoadError =>
      'Satın alma paketleri şu an yüklenemiyor.';

  @override
  String profileCreditsAdded(int credits) {
    return '$credits kredi eklendi ✓';
  }

  @override
  String profilePurchaseCompletedButCreditsFailed(String error) {
    return 'Satın alma tamamlandı ama kredi eklenemedi: $error';
  }

  @override
  String get profilePurchaseFailed => 'Satın alma başarısız.';

  @override
  String profileCreditsSuffix(int credits) {
    return '$credits kredi';
  }

  @override
  String get profileSignOut => 'Çıkış Yap';
}
