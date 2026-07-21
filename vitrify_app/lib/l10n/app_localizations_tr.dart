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
      'Ürün fotoğraflarını yükle, kredini kullanarak yapay zeka senin için görseller üretsin.';

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
  String get promptsSceneLabel => 'Mekan';

  @override
  String get promptsScenarioLabel => 'Senaryolar';

  @override
  String get promptCatJewelryName => 'Takılar';

  @override
  String get promptCatJewelryScene =>
      'Kadife dokulu bir zeminde, yumuşak ve sıcak stüdyo ışığıyla aydınlatılmış şık bir mücevher sergisi';

  @override
  String get promptCatJewelryScenario1 =>
      'bir kadının bileğinde, zarif bir el pozuyla';

  @override
  String get promptCatJewelryScenario2 =>
      'açık bir mücevher kutusunun içinde, kutunun kadife astarı üzerinde';

  @override
  String get promptCatJewelryScenario3 =>
      'parlak bir mermer zemin üzerinde, yandan gelen yumuşak bir ışıkla';

  @override
  String get promptCatWatchName => 'Saatler';

  @override
  String get promptCatWatchScene =>
      'Koyu ahşap bir masa üzerinde, minimalist ve erkeksi bir stüdyo ortamı, keskin ama yumuşak ışık';

  @override
  String get promptCatWatchScenario1 =>
      'bir erkeğin bileğinde, gömlek koluyla birlikte';

  @override
  String get promptCatWatchScenario2 =>
      'bir saat kutusunun içinde, kutunun yumuşak astarı üzerinde sergileniyor';

  @override
  String get promptCatWatchScenario3 =>
      'deri bir defterin yanında, masa üzeri düzenlemesinde';

  @override
  String get promptCatGlassesName => 'Gözlükler';

  @override
  String get promptCatGlassesScene =>
      'Güneşli bir kafe terasında, doğal gün ışığı ve hafif bulanık bir şehir manzarası arka planda';

  @override
  String get promptCatGlassesScenario1 => 'bir kişinin yüzünde, gülümserken';

  @override
  String get promptCatGlassesScenario2 =>
      'masanın üzerinde katlanmış şekilde, yanında açık bir kitapla';

  @override
  String get promptCatGlassesScenario3 =>
      'bir elin içinde tutuluyor, arka planda açık gökyüzüyle';

  @override
  String get promptCatTshirtName => 'Tişört & Üst Giyim';

  @override
  String get promptCatTshirtScene =>
      'Minimalist bir stüdyo, düz pastel tonlu bir arka plan ve yumuşak, dengeli stüdyo ışığı';

  @override
  String get promptCatTshirtScenario1 =>
      'bir manken üzerinde, önden düz bir çekimle';

  @override
  String get promptCatTshirtScenario2 =>
      'gündelik bir sokak ortamında yürüyen bir kişinin üzerinde';

  @override
  String get promptCatTshirtScenario3 =>
      'ahşap bir askıda, doğal pencere ışığıyla asılı şekilde';

  @override
  String get promptCatPantsName => 'Pantolonlar';

  @override
  String get promptCatPantsScene =>
      'Modern bir giyinme odası, sıcak ahşap zemin ve yumuşak yandan gelen ışık';

  @override
  String get promptCatPantsScenario1 =>
      'bir kişinin üzerinde, rahat bir ayakta duruş pozuyla';

  @override
  String get promptCatPantsScenario2 =>
      'özenle katlanmış şekilde bir sandalyenin üzerinde';

  @override
  String get promptCatPantsScenario3 =>
      'bir mağaza vitrininde diğer kıyafetlerle birlikte sergileniyor';

  @override
  String get promptCatJacketName => 'Ceket & Mont';

  @override
  String get promptCatJacketScene =>
      'Şehir sokağında sonbahar atmosferi, dökülen yapraklar ve yumuşak gündüz ışığı';

  @override
  String get promptCatJacketScenario1 =>
      'bir kişinin üzerinde, yürürken yakalanmış doğal bir poz';

  @override
  String get promptCatJacketScenario2 =>
      'ahşap bir askıya asılı, mağaza içi bir ortamda';

  @override
  String get promptCatJacketScenario3 =>
      'omuzdan tek elle tutulan, gündelik bir poz';

  @override
  String get promptCatBagName => 'Çantalar';

  @override
  String get promptCatBagScene =>
      'Şık bir kafe masası düzenlemesi, yanında bir fincan kahve ve bir dergiyle, yumuşak doğal ışık';

  @override
  String get promptCatBagScenario1 =>
      'bir kadının omzunda taşınıyor, gündelik bir yürüyüş pozunda';

  @override
  String get promptCatBagScenario2 =>
      'bir sandalyenin üzerinde rahatça bırakılmış şekilde';

  @override
  String get promptCatBagScenario3 =>
      'elde tutulan, şehir içinde yürüme anında';

  @override
  String get promptCatShoesName => 'Ayakkabılar';

  @override
  String get promptCatShoesScene =>
      'Beton dokulu bir zeminde sokak stili bir sahne, sert ama sıcak gün ışığı';

  @override
  String get promptCatShoesScenario1 =>
      'bir kişinin ayağında, yürüme anında yakalanmış';

  @override
  String get promptCatShoesScenario2 =>
      'kutusunun yanında, düzenli bir sergileme şeklinde';

  @override
  String get promptCatShoesScenario3 =>
      'merdiven basamağında, yandan gelen ışıkla çekilmiş';

  @override
  String get promptCatCosmeticsName => 'Kozmetik & Cilt Bakımı';

  @override
  String get promptCatCosmeticsScene =>
      'Beyaz mermer bir tezgah üzerinde, yumuşak ve temiz bir banyo/spa atmosferi, doğal ışıkla aydınlatılmış';

  @override
  String get promptCatCosmeticsScenario1 =>
      'yanında yeşil yapraklar ve bir havluyla düzenlenmiş';

  @override
  String get promptCatCosmeticsScenario2 =>
      'bir kadının elinde, cilde uygulanırken';

  @override
  String get promptCatCosmeticsScenario3 =>
      'su damlacıklarıyla, ürünün üzerine ışık vurarak';

  @override
  String get promptCatPerfumeName => 'Parfüm';

  @override
  String get promptCatPerfumeScene =>
      'Zarif bir tuvalet masası üzerinde, altın detaylı bir ayna önünde, akşam ışığıyla aydınlatılmış';

  @override
  String get promptCatPerfumeScenario1 =>
      'ipek bir kumaşın üzerinde, yanında taze çiçeklerle';

  @override
  String get promptCatPerfumeScenario2 =>
      'bir kadının elinde, kendine sıkarken';

  @override
  String get promptCatPerfumeScenario3 =>
      'karanlık bir zemin üzerinde, dramatik bir ışıkla vurgulanmış';

  @override
  String get promptCatElectronicsName => 'Elektronik';

  @override
  String get promptCatElectronicsScene =>
      'Modern bir çalışma masası, minimalist dekor, düzenli kablolar ve yumuşak ofis ışığı';

  @override
  String get promptCatElectronicsScenario1 =>
      'bir kişinin elinde tutuluyor, kullanılırken';

  @override
  String get promptCatElectronicsScenario2 =>
      'masanın üzerinde, dizüstü bilgisayar ve bir kahve fincanıyla birlikte';

  @override
  String get promptCatElectronicsScenario3 =>
      'kutusunun yanında, açılmış paketleme ile sergileniyor';

  @override
  String get promptCatFurnitureName => 'Mobilya';

  @override
  String get promptCatFurnitureScene =>
      'Sıcak ışıklı, modern bir oturma odası, büyük bir pencereden gelen doğal ışıkla';

  @override
  String get promptCatFurnitureScenario1 =>
      'odanın merkezinde, diğer dekorasyon parçalarıyla uyumlu şekilde';

  @override
  String get promptCatFurnitureScenario2 =>
      'üzerine bir kitap ve bir bitki konmuş şekilde';

  @override
  String get promptCatFurnitureScenario3 =>
      'akşam ışığında, sıcak bir atmosferde';

  @override
  String get promptCatHomeDecorName => 'Ev Dekorasyonu';

  @override
  String get promptCatHomeDecorScene =>
      'Minimalist bir raf düzenlemesi, doğal dokular (ahşap, keten) ve yumuşak gündüz ışığı';

  @override
  String get promptCatHomeDecorScenario1 =>
      'bir rafın üzerinde, kitaplar ve bir mumla birlikte';

  @override
  String get promptCatHomeDecorScenario2 =>
      'bir masanın ortasında, çiçek düzenlemesiyle';

  @override
  String get promptCatHomeDecorScenario3 =>
      'duvara yakın, gölge oyunlarıyla dramatik bir ışıklandırmayla';

  @override
  String get promptCatKitchenName => 'Mutfak Eşyaları';

  @override
  String get promptCatKitchenScene =>
      'Modern bir mutfak tezgahı, mermer yüzey ve pencereden gelen doğal sabah ışığı';

  @override
  String get promptCatKitchenScenario1 =>
      'taze malzemelerle (sebze, meyve) birlikte düzenlenmiş';

  @override
  String get promptCatKitchenScenario2 => 'kullanılırken, bir elin içinde';

  @override
  String get promptCatKitchenScenario3 =>
      'diğer mutfak eşyalarıyla bir arada, düzenli bir raf üzerinde';

  @override
  String get promptCatBabyName => 'Bebek & Çocuk';

  @override
  String get promptCatBabyScene =>
      'Yumuşak pastel tonlarda bir çocuk odası, oyuncaklar ve sıcak, güven veren bir ışıkla';

  @override
  String get promptCatBabyScenario1 => 'bir bebeğin yanında, beşiğin içinde';

  @override
  String get promptCatBabyScenario2 => 'bir çocuğun elinde, oynarken';

  @override
  String get promptCatBabyScenario3 =>
      'diğer oyuncaklarla birlikte, halının üzerinde düzenlenmiş';

  @override
  String get promptCatSportsName => 'Spor & Fitness';

  @override
  String get promptCatSportsScene =>
      'Modern bir spor salonu ya da açık hava antrenman alanı, enerjik ve dinamik bir ışıkla';

  @override
  String get promptCatSportsScenario1 =>
      'bir kişi antrenman yaparken kullanılıyor';

  @override
  String get promptCatSportsScenario2 =>
      'bir yoga matının üzerinde, düzenli şekilde yerleştirilmiş';

  @override
  String get promptCatSportsScenario3 =>
      'spor çantasının yanında, antrenman öncesi düzenlemesinde';
}
