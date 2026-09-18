// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get genericErrorMessage =>
      'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get commonOk => 'Tamam';

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
  String get loginForgotPassword => 'Şifremi unuttum?';

  @override
  String get loginEnterEmailFirst => 'Önce e-posta adresini gir.';

  @override
  String get loginPasswordResetSent =>
      'Şifre sıfırlama bağlantısı e-postana gönderildi.';

  @override
  String get loginOrDivider => 'veya';

  @override
  String get loginGoogleSignIn => 'Google ile Giriş Yap';

  @override
  String get navTheme => 'Tema';

  @override
  String get navCreate => 'Oluştur';

  @override
  String get navGallery => 'Galeri';

  @override
  String get navProfile => 'Profil';

  @override
  String get navPrompts => 'Öneriler';

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
  String get createSafeToCloseApp =>
      'Üretim başladı. Uygulamayı kapatabilirsiniz — görselleriniz hazır olduğunda size bildirim göndereceğiz.';

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
  String get galleryDeviceSaveFailed => 'Görsel cihaza kaydedilemedi.';

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
  String get profilePurchaseCompletedButCreditsFailed =>
      'Satın alma tamamlandı ama kredi eklenemedi. Lütfen destek ile iletişime geçin.';

  @override
  String get profilePurchaseFailed => 'Satın alma başarısız.';

  @override
  String profileCreditsSuffix(int credits) {
    return '$credits kredi';
  }

  @override
  String get profileSignOut => 'Çıkış Yap';

  @override
  String get profileThemeTitle => 'Görünüm';

  @override
  String get profileThemeLight => 'Açık';

  @override
  String get profileThemeDark => 'Koyu';

  @override
  String get profileThemeSystem => 'Sistem';

  @override
  String get onboardingSkip => 'Geç';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingGetStarted => 'Başla';

  @override
  String get onboardingPage1Title => 'Vitrify\'a Hoş Geldin';

  @override
  String get onboardingPage1Body =>
      'Yapay zeka ile ürün fotoğraflarını saniyeler içinde profesyonel sahnelere dönüştür.';

  @override
  String get onboardingPage2Title => '1. Tema Oluştur';

  @override
  String get onboardingPage2Body =>
      'Ürünlerinin sergileneceği mekanı ve senaryoları tanımla — bu ayarlar cihazında saklanır.';

  @override
  String get onboardingPage3Title => '2. Üret';

  @override
  String get onboardingPage3Body =>
      'Ürün fotoğraflarını yükle, kredini kullanarak yapay zeka senin için görseller üretsin. Not: yapay zeka üretimi marka logolarında/metinlerinde küçük farklılıklara yol açabilir, üretilen görselleri kullanmadan önce gözden geçirmeni öneririz.';

  @override
  String get onboardingPage4Title => '3. Görüntüle ve Yönet';

  @override
  String get onboardingPage4Body =>
      'Üretilen görselleri Galeri\'de gör ya da cihazına kaydet, Profil\'de kredini takip et.';

  @override
  String get promptsAppBarTitle => 'Öneri Promptlar';

  @override
  String get promptsCopied => 'Kopyalandı ✓';

  @override
  String get promptsApplied =>
      'Ayarlandı! Oluştur sekmesinden kullanabilirsiniz.';

  @override
  String get promptsSceneLabel => 'Mekan';

  @override
  String get promptsScenarioLabel => 'Senaryolar';

  @override
  String get promptCatJewelryName => 'Takılar';

  @override
  String get promptCatJewelryScene =>
      'Saf beyaz bir stüdyo zemininde, yumuşak ve eşit dağılan profesyonel ışıkla aydınlatılmış, gölgesi minimal sade bir mücevher sergisi';

  @override
  String get promptCatJewelryScenario1 =>
      'beyaz bir platform üzerinde, ortalanmış ve simetrik şekilde';

  @override
  String get promptCatJewelryScenario2 =>
      'hafif yükseltilmiş şeffaf bir stant üzerinde sergileniyor';

  @override
  String get promptCatJewelryScenario3 =>
      'yumuşak, yandan gelen ışıkla vurgulanmış, ince bir gölgeyle';

  @override
  String get promptCatWatchName => 'Saatler';

  @override
  String get promptCatWatchScene =>
      'Nötr beyaz-gri tonlarında minimalist bir stüdyo zemini, yumuşak ve dengeli profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatWatchScenario1 =>
      'beyaz bir küp platform üzerinde, kadranı öne bakacak şekilde';

  @override
  String get promptCatWatchScenario2 =>
      'hafif eğik bir açıyla, kayışı kıvrımlı şekilde yerleştirilmiş';

  @override
  String get promptCatWatchScenario3 =>
      'ince şeffaf bir stant üzerinde dik duruşta';

  @override
  String get promptCatGlassesName => 'Gözlükler';

  @override
  String get promptCatGlassesScene =>
      'Saf beyaz bir zemin üzerinde, yumuşak ve gölgesiz stüdyo ışığıyla aydınlatılmış sade bir ürün sergisi';

  @override
  String get promptCatGlassesScenario1 =>
      'katlanmış halde, düzgün ve simetrik yerleştirilmiş';

  @override
  String get promptCatGlassesScenario2 =>
      'hafif açık şekilde, yandan görünümde';

  @override
  String get promptCatGlassesScenario3 =>
      'ince bir stant üzerinde dik durur şekilde';

  @override
  String get promptCatTshirtName => 'Tişört & Üst Giyim';

  @override
  String get promptCatTshirtScene =>
      'Düz beyaz arka planlı minimalist bir stüdyo, yumuşak ve dengeli profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatTshirtScenario1 =>
      'görünmez bir manken üzerinde, önden düz ve simetrik görünüm';

  @override
  String get promptCatTshirtScenario2 =>
      'özenle katlanmış şekilde, düzenli bir yığın halinde';

  @override
  String get promptCatTshirtScenario3 =>
      'ince bir askıda, düz ve kırışıksız şekilde asılı';

  @override
  String get promptCatPantsName => 'Pantolonlar';

  @override
  String get promptCatPantsScene =>
      'Düz beyaz arka planlı minimalist bir stüdyo, yumuşak ve dengeli profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatPantsScenario1 =>
      'görünmez bir manken üzerinde, önden düz görünüm';

  @override
  String get promptCatPantsScenario2 =>
      'özenle katlanmış şekilde, düzenli bir yığın halinde';

  @override
  String get promptCatPantsScenario3 => 'ince bir askıda düz şekilde asılı';

  @override
  String get promptCatJacketName => 'Ceket & Mont';

  @override
  String get promptCatJacketScene =>
      'Düz beyaz arka planlı minimalist bir stüdyo, yumuşak ve dengeli profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatJacketScenario1 =>
      'görünmez bir manken üzerinde, önden düz görünüm';

  @override
  String get promptCatJacketScenario2 =>
      'ahşap ya da metal bir askıda, düzgün asılı şekilde';

  @override
  String get promptCatJacketScenario3 =>
      'hafif 3/4 açıyla, yaka ve detayları görünecek şekilde';

  @override
  String get promptCatBagName => 'Çantalar';

  @override
  String get promptCatBagScene =>
      'Saf beyaz bir zemin üzerinde, yumuşak stüdyo ışığıyla aydınlatılmış sade bir ürün sergisi';

  @override
  String get promptCatBagScenario1 =>
      'dik duruşta, kendi tabanı üzerinde ortalanmış';

  @override
  String get promptCatBagScenario2 => 'yandan görünümde, sapı belirgin şekilde';

  @override
  String get promptCatBagScenario3 =>
      'hafif yükseltilmiş bir platform üzerinde, üstten hafif açılı görünüm';

  @override
  String get promptCatShoesName => 'Ayakkabılar';

  @override
  String get promptCatShoesScene =>
      'Saf beyaz bir zemin üzerinde, yumuşak ve net stüdyo ışığıyla aydınlatılmış sade bir ürün sergisi';

  @override
  String get promptCatShoesScenario1 => 'yan profilden, tek başına ortalanmış';

  @override
  String get promptCatShoesScenario2 =>
      'hafif açılı 3/4 görünümde, çift olarak yan yana';

  @override
  String get promptCatShoesScenario3 =>
      'üstten düz görünümde, simetrik yerleşimle';

  @override
  String get promptCatCosmeticsName => 'Kozmetik & Cilt Bakımı';

  @override
  String get promptCatCosmeticsScene =>
      'Beyaz mermer ya da mat beyaz bir yüzey üzerinde, yumuşak ve temiz stüdyo ışığıyla aydınlatılmış';

  @override
  String get promptCatCosmeticsScenario1 =>
      'dik duruşta, ortalanmış ve simetrik şekilde';

  @override
  String get promptCatCosmeticsScenario2 =>
      'hafif yandan gelen ışıkla, ince bir gölgeyle vurgulanmış';

  @override
  String get promptCatCosmeticsScenario3 =>
      'kapağı kapalı, düzenli ve sade bir yerleşimle';

  @override
  String get promptCatPerfumeName => 'Parfüm';

  @override
  String get promptCatPerfumeScene =>
      'Saf beyaz bir zemin üzerinde, yumuşak ve net stüdyo ışığıyla aydınlatılmış zarif bir sergileme';

  @override
  String get promptCatPerfumeScenario1 => 'şişe dik duruşta, tam ortalanmış';

  @override
  String get promptCatPerfumeScenario2 =>
      'hafif yansımalı beyaz bir zeminde, ince bir yansımayla';

  @override
  String get promptCatPerfumeScenario3 =>
      'yandan gelen yumuşak ışıkla, cam dokusu belirginleşecek şekilde';

  @override
  String get promptCatElectronicsName => 'Elektronik';

  @override
  String get promptCatElectronicsScene =>
      'Minimalist gri-beyaz bir stüdyo zemini, yumuşak ve dengeli profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatElectronicsScenario1 => 'önden düz ve simetrik görünüm';

  @override
  String get promptCatElectronicsScenario2 => 'hafif açılı 3/4 görünümde';

  @override
  String get promptCatElectronicsScenario3 =>
      'üstten düz görünümde, düzenli yerleşimle';

  @override
  String get promptCatFurnitureName => 'Mobilya';

  @override
  String get promptCatFurnitureScene =>
      'Beyaz/açık gri sonsuzluk (infinity) zemin üzerinde, yumuşak ve eşit dağılan profesyonel stüdyo ışığı';

  @override
  String get promptCatFurnitureScenario1 => 'önden düz ve simetrik görünüm';

  @override
  String get promptCatFurnitureScenario2 => 'hafif açılı köşe görünümünde';

  @override
  String get promptCatFurnitureScenario3 =>
      'yandan profil görünümünde, net hatlarla';

  @override
  String get promptCatHomeDecorName => 'Ev Dekorasyonu';

  @override
  String get promptCatHomeDecorScene =>
      'Sade beyaz bir raf/zemin düzenlemesi, yumuşak ve dengeli profesyonel stüdyo ışığı';

  @override
  String get promptCatHomeDecorScenario1 =>
      'ortalanmış, tek başına sade bir sergileme';

  @override
  String get promptCatHomeDecorScenario2 =>
      'hafif yükseltilmiş bir platform üzerinde';

  @override
  String get promptCatHomeDecorScenario3 =>
      'yandan gelen yumuşak ışıkla, ince bir gölgeyle vurgulanmış';

  @override
  String get promptCatKitchenName => 'Mutfak Eşyaları';

  @override
  String get promptCatKitchenScene =>
      'Beyaz mermer görünümlü bir tezgah üzerinde, yumuşak ve net profesyonel stüdyo ışığı';

  @override
  String get promptCatKitchenScenario1 => 'dik/düz duruşta, ortalanmış şekilde';

  @override
  String get promptCatKitchenScenario2 => 'hafif açılı üstten görünümde';

  @override
  String get promptCatKitchenScenario3 =>
      'yandan gelen ışıkla, doku ve detaylar belirginleşecek şekilde';

  @override
  String get promptCatBabyName => 'Bebek & Çocuk';

  @override
  String get promptCatBabyScene =>
      'Yumuşak beyaz-pastel tonlarında sade bir stüdyo zemini, yumuşak ve güven veren profesyonel ışık';

  @override
  String get promptCatBabyScenario1 =>
      'tek başına, ortalanmış sade bir sergileme';

  @override
  String get promptCatBabyScenario2 =>
      'hafif yükseltilmiş bir platform üzerinde';

  @override
  String get promptCatBabyScenario3 =>
      'üstten düz görünümde, düzenli yerleşimle';

  @override
  String get promptCatSportsName => 'Spor & Fitness';

  @override
  String get promptCatSportsScene =>
      'Minimalist beyaz-gri bir stüdyo zemini, enerjik ama sade bir profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatSportsScenario1 => 'önden düz ve simetrik görünüm';

  @override
  String get promptCatSportsScenario2 => 'hafif açılı 3/4 görünümde';

  @override
  String get promptCatSportsScenario3 =>
      'üstten düz görünümde, düzenli yerleşimle';
}
