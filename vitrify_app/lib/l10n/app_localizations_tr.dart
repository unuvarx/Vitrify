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
      'Sade ve şık bir stüdyo ortamı, açık nötr tonlarda, ince bir kumaş örtü ve minimal bir mücevher standı bulunan, yumuşak profesyonel ışıkla aydınlatılmış bir sergi düzeni';

  @override
  String get promptCatJewelryScenario1 =>
      'beyaz bir mücevher standı üzerinde, ürünün tamamı kadrajda, yakın çekim olmadan';

  @override
  String get promptCatJewelryScenario2 =>
      'yanında sade bir mücevher kutusuyla, geniş bir masaüstü düzenlemesinde';

  @override
  String get promptCatJewelryScenario3 =>
      'yumuşak yandan ışıkla, yanında ince bir dekoratif objeyle, ürün bütünüyle görünür şekilde';

  @override
  String get promptCatWatchName => 'Saatler';

  @override
  String get promptCatWatchScene =>
      'Şık ve sade bir stüdyo masası düzeni, açık gri-beyaz tonlarda, yanında ince bir saat standı ve minimal bir dekor öğesi bulunan, yumuşak profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatWatchScenario1 =>
      'bir saat standı üzerinde, kadranı öne bakacak şekilde, ürünün tamamı kadrajda';

  @override
  String get promptCatWatchScenario2 =>
      'masa üzerinde hafif eğik açıyla, yanında sade bir defterle, yakın çekim olmadan';

  @override
  String get promptCatWatchScenario3 =>
      'ince bir vitrin kutusu içinde sergileniyor, geniş kadrajda';

  @override
  String get promptCatGlassesName => 'Gözlükler';

  @override
  String get promptCatGlassesScene =>
      'Sade ve modern bir stüdyo masası düzeni, açık nötr tonlarda, yanında ince bir kitap ve minimal bir dekor öğesi bulunan, yumuşak ışıkla aydınlatılmış';

  @override
  String get promptCatGlassesScenario1 =>
      'katlanmış halde, yanında sade bir kitapla, ürünün tamamı geniş kadrajda';

  @override
  String get promptCatGlassesScenario2 =>
      'ince bir gözlük standı üzerinde dik durur şekilde, yakın çekim olmadan';

  @override
  String get promptCatGlassesScenario3 =>
      'masa üzerinde hafif açık şekilde, yandan görünümde, ürün bütünüyle görünür';

  @override
  String get promptCatTshirtName => 'Tişört & Üst Giyim';

  @override
  String get promptCatTshirtScene =>
      'Sade ve modern bir stüdyo ortamı, açık nötr tonlu bir arka plan, yumuşak profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatTshirtScenario1 =>
      'bir manken üzerinde, önden düz görünüm, ürünün tamamı kadrajda';

  @override
  String get promptCatTshirtScenario2 =>
      'ahşap bir askılıkta asılı, geniş kadrajda, yakın çekim olmadan';

  @override
  String get promptCatTshirtScenario3 =>
      'özenle katlanmış şekilde, yanında sade bir dekor öğesiyle, masa üzerinde';

  @override
  String get promptCatPantsName => 'Pantolonlar';

  @override
  String get promptCatPantsScene =>
      'Sade ve modern bir stüdyo ortamı, açık nötr tonlu bir arka plan, yumuşak profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatPantsScenario1 =>
      'bir manken üzerinde, önden düz görünüm, ürünün tamamı kadrajda';

  @override
  String get promptCatPantsScenario2 =>
      'ahşap bir askılıkta asılı, geniş kadrajda';

  @override
  String get promptCatPantsScenario3 =>
      'özenle katlanmış şekilde, sade bir masa üzerinde';

  @override
  String get promptCatJacketName => 'Ceket & Mont';

  @override
  String get promptCatJacketScene =>
      'Sade ve modern bir stüdyo ortamı, açık nötr tonlu bir arka plan, yumuşak profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatJacketScenario1 =>
      'bir manken üzerinde, önden düz görünüm, ürünün tamamı kadrajda';

  @override
  String get promptCatJacketScenario2 =>
      'ahşap ya da metal bir askılıkta, mağaza içi sade bir düzenlemede, geniş kadrajda';

  @override
  String get promptCatJacketScenario3 =>
      'hafif 3/4 açıyla, yaka ve detaylar görünür ama ürünün tamamı kadrajda kalacak şekilde';

  @override
  String get promptCatBagName => 'Çantalar';

  @override
  String get promptCatBagScene =>
      'Sade ve şık bir stüdyo masası düzeni, açık nötr tonlarda, minimal bir dekor öğesi bulunan, yumuşak ışıkla aydınlatılmış';

  @override
  String get promptCatBagScenario1 =>
      'dik duruşta, kendi tabanı üzerinde, ürünün tamamı geniş kadrajda';

  @override
  String get promptCatBagScenario2 =>
      'yandan görünümde, sapı belirgin şekilde, yakın çekim olmadan';

  @override
  String get promptCatBagScenario3 =>
      'bir sandalye ya da tabure üzerinde, sade bir düzenlemede, geniş kadrajda';

  @override
  String get promptCatShoesName => 'Ayakkabılar';

  @override
  String get promptCatShoesScene =>
      'Sade ve modern bir stüdyo zemini, açık nötr tonlarda, yumuşak ve net profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatShoesScenario1 =>
      'yan profilden, tek başına, ürünün tamamı kadrajda, yakın çekim olmadan';

  @override
  String get promptCatShoesScenario2 =>
      'çift olarak yan yana, kutusunun yanında sade bir düzenlemede';

  @override
  String get promptCatShoesScenario3 =>
      'hafif açılı üstten görünümde, geniş kadrajda';

  @override
  String get promptCatCosmeticsName => 'Kozmetik & Cilt Bakımı';

  @override
  String get promptCatCosmeticsScene =>
      'Sade ve temiz bir banyo/spa tarzı düzenleme, açık nötr tonlarda, yanında ince bir havlu ve minimal bir dekor öğesi bulunan, yumuşak ışıkla aydınlatılmış';

  @override
  String get promptCatCosmeticsScenario1 =>
      'dik duruşta, yanında sade bir dekor öğesiyle, ürünün tamamı kadrajda, yakın çekim olmadan';

  @override
  String get promptCatCosmeticsScenario2 =>
      'hafif yandan gelen ışıkla, geniş bir kadrajda';

  @override
  String get promptCatCosmeticsScenario3 =>
      'kapağı kapalı, sade bir masa düzenlemesinde';

  @override
  String get promptCatPerfumeName => 'Parfüm';

  @override
  String get promptCatPerfumeScene =>
      'Zarif ve sade bir tuvalet masası düzeni, açık nötr tonlarda, yanında ince bir dekor öğesi (çiçek veya kumaş) bulunan, yumuşak ışıkla aydınlatılmış';

  @override
  String get promptCatPerfumeScenario1 =>
      'şişe dik duruşta, ürünün tamamı geniş kadrajda, yakın çekim olmadan';

  @override
  String get promptCatPerfumeScenario2 =>
      'hafif yansımalı bir yüzeyde, yanında sade bir dekor öğesiyle';

  @override
  String get promptCatPerfumeScenario3 =>
      'yandan gelen yumuşak ışıkla, geniş kadrajda';

  @override
  String get promptCatElectronicsName => 'Elektronik';

  @override
  String get promptCatElectronicsScene =>
      'Modern ve sade bir çalışma masası düzeni, minimalist dekor, düzenli kablolar, yumuşak profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatElectronicsScenario1 =>
      'masa üzerinde, önden düz görünüm, ürünün tamamı kadrajda';

  @override
  String get promptCatElectronicsScenario2 =>
      'yanında sade bir dekor öğesiyle (defter, fincan), hafif açılı görünümde';

  @override
  String get promptCatElectronicsScenario3 =>
      'kutusunun yanında sergileniyor, geniş kadrajda';

  @override
  String get promptCatFurnitureName => 'Mobilya';

  @override
  String get promptCatFurnitureScene =>
      'Sıcak ve sade bir oda düzeni, açık nötr tonlarda, doğal ışık ve minimal dekor öğeleriyle';

  @override
  String get promptCatFurnitureScenario1 =>
      'odanın içinde, diğer sade dekor öğeleriyle uyumlu şekilde, ürünün tamamı kadrajda';

  @override
  String get promptCatFurnitureScenario2 =>
      'hafif açılı köşe görünümünde, geniş kadrajda';

  @override
  String get promptCatFurnitureScenario3 =>
      'yandan profil görünümünde, sade bir düzenlemede';

  @override
  String get promptCatHomeDecorName => 'Ev Dekorasyonu';

  @override
  String get promptCatHomeDecorScene =>
      'Sade bir raf/masa düzenlemesi, doğal dokular (ahşap, keten) ve minimal dekor öğeleriyle, yumuşak ışıkla aydınlatılmış';

  @override
  String get promptCatHomeDecorScenario1 =>
      'bir rafın üzerinde, yanında sade bir dekor öğesiyle (kitap, mum)';

  @override
  String get promptCatHomeDecorScenario2 =>
      'masa ortasında, sade bir çiçek düzenlemesiyle, geniş kadrajda';

  @override
  String get promptCatHomeDecorScenario3 =>
      'yandan gelen yumuşak ışıkla, ürünün tamamı kadrajda';

  @override
  String get promptCatKitchenName => 'Mutfak Eşyaları';

  @override
  String get promptCatKitchenScene =>
      'Modern ve sade bir mutfak tezgahı düzeni, açık nötr tonlarda, doğal ışıkla aydınlatılmış';

  @override
  String get promptCatKitchenScenario1 =>
      'tezgah üzerinde, yanında sade malzemelerle (birkaç meyve/sebze), ürünün tamamı kadrajda';

  @override
  String get promptCatKitchenScenario2 =>
      'hafif açılı üstten görünümde, geniş kadrajda';

  @override
  String get promptCatKitchenScenario3 =>
      'diğer sade mutfak eşyalarıyla bir arada, düzenli bir rafta';

  @override
  String get promptCatBabyName => 'Bebek & Çocuk';

  @override
  String get promptCatBabyScene =>
      'Yumuşak pastel tonlarda sade bir çocuk odası düzeni, oyuncaklar ve minimal dekor öğeleriyle, sıcak ve güven veren ışıkla';

  @override
  String get promptCatBabyScenario1 =>
      'sade bir raf üzerinde, yanında bir-iki oyuncakla, ürünün tamamı kadrajda';

  @override
  String get promptCatBabyScenario2 =>
      'hafif yükseltilmiş bir platformda, geniş kadrajda';

  @override
  String get promptCatBabyScenario3 =>
      'halının üzerinde, düzenli ve sade bir yerleşimle';

  @override
  String get promptCatSportsName => 'Spor & Fitness';

  @override
  String get promptCatSportsScene =>
      'Modern ve sade bir spor alanı düzeni, açık nötr tonlarda, enerjik ama temiz profesyonel ışıkla aydınlatılmış';

  @override
  String get promptCatSportsScenario1 =>
      'bir yoga matının üzerinde, düzenli şekilde, ürünün tamamı kadrajda';

  @override
  String get promptCatSportsScenario2 =>
      'spor çantasının yanında, sade bir düzenlemede';

  @override
  String get promptCatSportsScenario3 =>
      'hafif açılı görünümde, geniş kadrajda';
}
