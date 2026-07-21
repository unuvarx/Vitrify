import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericErrorMessage(String error);

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @loginEmailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get loginEmailPasswordRequired;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHint;

  /// No description provided for @loginSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUpButton;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignInButton;

  /// No description provided for @loginSwitchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get loginSwitchToSignIn;

  /// No description provided for @loginSwitchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get loginSwitchToSignUp;

  /// No description provided for @loginCreditsLabel.
  ///
  /// In en, this message translates to:
  /// **'Credits: {credits}'**
  String loginCreditsLabel(int credits);

  /// No description provided for @navTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get navTheme;

  /// No description provided for @navCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get navCreate;

  /// No description provided for @navGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get navGallery;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navPrompts.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get navPrompts;

  /// No description provided for @themeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeAppBarTitle;

  /// No description provided for @themeSceneTitle.
  ///
  /// In en, this message translates to:
  /// **'Scene'**
  String get themeSceneTitle;

  /// No description provided for @themeSceneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the setting your products will be showcased in'**
  String get themeSceneSubtitle;

  /// No description provided for @themeSceneHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Around 9 AM, with the sun beautifully lighting the sea and beach, surrounded by islands'**
  String get themeSceneHint;

  /// No description provided for @themeScenariosTitle.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get themeScenariosTitle;

  /// No description provided for @themeScenariosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A separate image is generated for each scenario'**
  String get themeScenariosSubtitle;

  /// No description provided for @themeScenarioHint.
  ///
  /// In en, this message translates to:
  /// **'Scenario {index} — E.g.: worn on a woman\'s wrist'**
  String themeScenarioHint(int index);

  /// No description provided for @themeAspectRatioTitle.
  ///
  /// In en, this message translates to:
  /// **'Image Ratio'**
  String get themeAspectRatioTitle;

  /// No description provided for @themeAspectRatioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aspect ratio of the generated images'**
  String get themeAspectRatioSubtitle;

  /// No description provided for @themeScenePromptRequired.
  ///
  /// In en, this message translates to:
  /// **'A scene description is required.'**
  String get themeScenePromptRequired;

  /// No description provided for @themeScenarioRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one scenario is required.'**
  String get themeScenarioRequired;

  /// No description provided for @themeSaved.
  ///
  /// In en, this message translates to:
  /// **'Theme saved ✓'**
  String get themeSaved;

  /// No description provided for @themeSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get themeSaveButton;

  /// No description provided for @themeSavedButton.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get themeSavedButton;

  /// No description provided for @createAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createAppBarTitle;

  /// No description provided for @createFillThemeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the Theme page first.'**
  String get createFillThemeFirst;

  /// No description provided for @createSelectAtLeastOneImage.
  ///
  /// In en, this message translates to:
  /// **'Select at least one product image.'**
  String get createSelectAtLeastOneImage;

  /// No description provided for @createInsufficientCredits.
  ///
  /// In en, this message translates to:
  /// **'Insufficient credits. Required: {required}, Available: {available}'**
  String createInsufficientCredits(int required, int available);

  /// No description provided for @createSomeFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} image(s) failed.'**
  String createSomeFailed(int count);

  /// No description provided for @createTimeout.
  ///
  /// In en, this message translates to:
  /// **'The process took too long. Please try again.'**
  String get createTimeout;

  /// No description provided for @createProductImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get createProductImagesTitle;

  /// No description provided for @createSelectImages.
  ///
  /// In en, this message translates to:
  /// **'Select Images'**
  String get createSelectImages;

  /// No description provided for @createImagesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} image(s) selected'**
  String createImagesSelected(int count);

  /// No description provided for @createSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get createSubmitting;

  /// No description provided for @createGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get createGenerateButton;

  /// No description provided for @createGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get createGenerating;

  /// No description provided for @createCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed 🎉'**
  String get createCompleted;

  /// No description provided for @createGeneratedImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Generated Images'**
  String get createGeneratedImagesTitle;

  /// No description provided for @galleryAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryAppBarTitle;

  /// No description provided for @galleryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get galleryDeleteTitle;

  /// No description provided for @galleryDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'This image will be permanently deleted from your device.'**
  String get galleryDeleteContent;

  /// No description provided for @galleryCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get galleryCancel;

  /// No description provided for @galleryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get galleryDelete;

  /// No description provided for @gallerySavedToDevice.
  ///
  /// In en, this message translates to:
  /// **'Image saved to device gallery.'**
  String get gallerySavedToDevice;

  /// No description provided for @galleryPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Gallery permission was denied.'**
  String get galleryPermissionDenied;

  /// No description provided for @galleryDeviceSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the image to your device.'**
  String get galleryDeviceSaveFailed;

  /// No description provided for @galleryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No generated images yet.'**
  String get galleryEmpty;

  /// No description provided for @profileAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileAppBarTitle;

  /// No description provided for @profileCreditsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining Credits'**
  String get profileCreditsRemaining;

  /// No description provided for @profileBuyCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy Credits'**
  String get profileBuyCreditsTitle;

  /// No description provided for @profileBuyCreditsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add credits to generate more images'**
  String get profileBuyCreditsSubtitle;

  /// No description provided for @profileNoPackages.
  ///
  /// In en, this message translates to:
  /// **'No packages available for purchase right now.'**
  String get profileNoPackages;

  /// No description provided for @profilePackagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Purchase packages could not be loaded right now.'**
  String get profilePackagesLoadError;

  /// No description provided for @profileCreditsAdded.
  ///
  /// In en, this message translates to:
  /// **'{credits} credits added ✓'**
  String profileCreditsAdded(int credits);

  /// No description provided for @profilePurchaseCompletedButCreditsFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase completed but credits could not be added: {error}'**
  String profilePurchaseCompletedButCreditsFailed(String error);

  /// No description provided for @profilePurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed.'**
  String get profilePurchaseFailed;

  /// No description provided for @profileCreditsSuffix.
  ///
  /// In en, this message translates to:
  /// **'{credits} credits'**
  String profileCreditsSuffix(int credits);

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @profileThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileThemeTitle;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profileThemeSystem;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Vitrify'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Body.
  ///
  /// In en, this message translates to:
  /// **'Turn product photos into professional scenes in seconds with AI.'**
  String get onboardingPage1Body;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'1. Create a Theme'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Body.
  ///
  /// In en, this message translates to:
  /// **'Describe the scene and scenarios your products will be shown in — saved on your device.'**
  String get onboardingPage2Body;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'2. Generate'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Body.
  ///
  /// In en, this message translates to:
  /// **'Upload your product photos and let AI generate images using your credits.'**
  String get onboardingPage3Body;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'3. View & Manage'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Body.
  ///
  /// In en, this message translates to:
  /// **'View or save generated images in Gallery, and track your credits in Profile.'**
  String get onboardingPage4Body;

  /// No description provided for @promptsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested Prompts'**
  String get promptsAppBarTitle;

  /// No description provided for @promptsCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied ✓'**
  String get promptsCopied;

  /// No description provided for @promptsSceneLabel.
  ///
  /// In en, this message translates to:
  /// **'Scene'**
  String get promptsSceneLabel;

  /// No description provided for @promptsScenarioLabel.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get promptsScenarioLabel;

  /// No description provided for @promptCatJewelryName.
  ///
  /// In en, this message translates to:
  /// **'Jewelry'**
  String get promptCatJewelryName;

  /// No description provided for @promptCatJewelryScene.
  ///
  /// In en, this message translates to:
  /// **'An elegant jewelry display on a velvet-textured surface, lit with soft, warm studio lighting'**
  String get promptCatJewelryScene;

  /// No description provided for @promptCatJewelryScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a woman\'s wrist, in an elegant hand pose'**
  String get promptCatJewelryScenario1;

  /// No description provided for @promptCatJewelryScenario2.
  ///
  /// In en, this message translates to:
  /// **'inside an open jewelry box, resting on its velvet lining'**
  String get promptCatJewelryScenario2;

  /// No description provided for @promptCatJewelryScenario3.
  ///
  /// In en, this message translates to:
  /// **'on a glossy marble surface, lit with soft side lighting'**
  String get promptCatJewelryScenario3;

  /// No description provided for @promptCatWatchName.
  ///
  /// In en, this message translates to:
  /// **'Watches'**
  String get promptCatWatchName;

  /// No description provided for @promptCatWatchScene.
  ///
  /// In en, this message translates to:
  /// **'A minimalist, masculine studio setting on a dark wooden table, with sharp yet soft lighting'**
  String get promptCatWatchScene;

  /// No description provided for @promptCatWatchScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a man\'s wrist, alongside a shirt sleeve'**
  String get promptCatWatchScenario1;

  /// No description provided for @promptCatWatchScenario2.
  ///
  /// In en, this message translates to:
  /// **'displayed inside a watch box, resting on its soft lining'**
  String get promptCatWatchScenario2;

  /// No description provided for @promptCatWatchScenario3.
  ///
  /// In en, this message translates to:
  /// **'next to a leather notebook, in a desk-top flat lay'**
  String get promptCatWatchScenario3;

  /// No description provided for @promptCatGlassesName.
  ///
  /// In en, this message translates to:
  /// **'Glasses'**
  String get promptCatGlassesName;

  /// No description provided for @promptCatGlassesScene.
  ///
  /// In en, this message translates to:
  /// **'On a sunny café terrace, with natural daylight and a softly blurred city view in the background'**
  String get promptCatGlassesScene;

  /// No description provided for @promptCatGlassesScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a person\'s face, while smiling'**
  String get promptCatGlassesScenario1;

  /// No description provided for @promptCatGlassesScenario2.
  ///
  /// In en, this message translates to:
  /// **'folded on a table, next to an open book'**
  String get promptCatGlassesScenario2;

  /// No description provided for @promptCatGlassesScenario3.
  ///
  /// In en, this message translates to:
  /// **'held in a hand, with an open sky in the background'**
  String get promptCatGlassesScenario3;

  /// No description provided for @promptCatTshirtName.
  ///
  /// In en, this message translates to:
  /// **'T-Shirts & Tops'**
  String get promptCatTshirtName;

  /// No description provided for @promptCatTshirtScene.
  ///
  /// In en, this message translates to:
  /// **'A minimalist studio with a flat pastel-toned background and soft, balanced studio lighting'**
  String get promptCatTshirtScene;

  /// No description provided for @promptCatTshirtScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a mannequin, in a straight-on front shot'**
  String get promptCatTshirtScenario1;

  /// No description provided for @promptCatTshirtScenario2.
  ///
  /// In en, this message translates to:
  /// **'worn by a person walking in a casual street setting'**
  String get promptCatTshirtScenario2;

  /// No description provided for @promptCatTshirtScenario3.
  ///
  /// In en, this message translates to:
  /// **'hanging on a wooden hanger, lit by natural window light'**
  String get promptCatTshirtScenario3;

  /// No description provided for @promptCatPantsName.
  ///
  /// In en, this message translates to:
  /// **'Pants'**
  String get promptCatPantsName;

  /// No description provided for @promptCatPantsScene.
  ///
  /// In en, this message translates to:
  /// **'A modern dressing room with warm wooden flooring and soft side lighting'**
  String get promptCatPantsScene;

  /// No description provided for @promptCatPantsScenario1.
  ///
  /// In en, this message translates to:
  /// **'worn by a person, in a relaxed standing pose'**
  String get promptCatPantsScenario1;

  /// No description provided for @promptCatPantsScenario2.
  ///
  /// In en, this message translates to:
  /// **'neatly folded on top of a chair'**
  String get promptCatPantsScenario2;

  /// No description provided for @promptCatPantsScenario3.
  ///
  /// In en, this message translates to:
  /// **'displayed in a store window alongside other garments'**
  String get promptCatPantsScenario3;

  /// No description provided for @promptCatJacketName.
  ///
  /// In en, this message translates to:
  /// **'Jackets & Coats'**
  String get promptCatJacketName;

  /// No description provided for @promptCatJacketScene.
  ///
  /// In en, this message translates to:
  /// **'An autumn atmosphere on a city street, with falling leaves and soft daylight'**
  String get promptCatJacketScene;

  /// No description provided for @promptCatJacketScenario1.
  ///
  /// In en, this message translates to:
  /// **'worn by a person, in a natural pose captured mid-walk'**
  String get promptCatJacketScenario1;

  /// No description provided for @promptCatJacketScenario2.
  ///
  /// In en, this message translates to:
  /// **'hanging on a wooden hanger in a store interior'**
  String get promptCatJacketScenario2;

  /// No description provided for @promptCatJacketScenario3.
  ///
  /// In en, this message translates to:
  /// **'held over the shoulder with one hand, in a casual pose'**
  String get promptCatJacketScenario3;

  /// No description provided for @promptCatBagName.
  ///
  /// In en, this message translates to:
  /// **'Bags'**
  String get promptCatBagName;

  /// No description provided for @promptCatBagScene.
  ///
  /// In en, this message translates to:
  /// **'A stylish café table flat lay, with a cup of coffee and a magazine, in soft natural light'**
  String get promptCatBagScene;

  /// No description provided for @promptCatBagScenario1.
  ///
  /// In en, this message translates to:
  /// **'carried on a woman\'s shoulder, in a casual walking pose'**
  String get promptCatBagScenario1;

  /// No description provided for @promptCatBagScenario2.
  ///
  /// In en, this message translates to:
  /// **'casually placed on top of a chair'**
  String get promptCatBagScenario2;

  /// No description provided for @promptCatBagScenario3.
  ///
  /// In en, this message translates to:
  /// **'held by hand, captured while walking in the city'**
  String get promptCatBagScenario3;

  /// No description provided for @promptCatShoesName.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get promptCatShoesName;

  /// No description provided for @promptCatShoesScene.
  ///
  /// In en, this message translates to:
  /// **'A street-style scene on a textured concrete surface, with hard yet warm daylight'**
  String get promptCatShoesScene;

  /// No description provided for @promptCatShoesScenario1.
  ///
  /// In en, this message translates to:
  /// **'worn on a person\'s foot, captured mid-step'**
  String get promptCatShoesScenario1;

  /// No description provided for @promptCatShoesScenario2.
  ///
  /// In en, this message translates to:
  /// **'displayed neatly next to its box'**
  String get promptCatShoesScenario2;

  /// No description provided for @promptCatShoesScenario3.
  ///
  /// In en, this message translates to:
  /// **'on a staircase step, photographed with side lighting'**
  String get promptCatShoesScenario3;

  /// No description provided for @promptCatCosmeticsName.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics & Skincare'**
  String get promptCatCosmeticsName;

  /// No description provided for @promptCatCosmeticsScene.
  ///
  /// In en, this message translates to:
  /// **'On a white marble countertop, in a soft and clean bathroom/spa atmosphere, lit with natural light'**
  String get promptCatCosmeticsScene;

  /// No description provided for @promptCatCosmeticsScenario1.
  ///
  /// In en, this message translates to:
  /// **'arranged next to green leaves and a towel'**
  String get promptCatCosmeticsScenario1;

  /// No description provided for @promptCatCosmeticsScenario2.
  ///
  /// In en, this message translates to:
  /// **'held in a woman\'s hand, while being applied to skin'**
  String get promptCatCosmeticsScenario2;

  /// No description provided for @promptCatCosmeticsScenario3.
  ///
  /// In en, this message translates to:
  /// **'with water droplets, light reflecting off the product'**
  String get promptCatCosmeticsScenario3;

  /// No description provided for @promptCatPerfumeName.
  ///
  /// In en, this message translates to:
  /// **'Perfume'**
  String get promptCatPerfumeName;

  /// No description provided for @promptCatPerfumeScene.
  ///
  /// In en, this message translates to:
  /// **'On an elegant vanity table, in front of a gold-detailed mirror, lit with evening light'**
  String get promptCatPerfumeScene;

  /// No description provided for @promptCatPerfumeScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a silk fabric, next to fresh flowers'**
  String get promptCatPerfumeScenario1;

  /// No description provided for @promptCatPerfumeScenario2.
  ///
  /// In en, this message translates to:
  /// **'held in a woman\'s hand, while spraying it on'**
  String get promptCatPerfumeScenario2;

  /// No description provided for @promptCatPerfumeScenario3.
  ///
  /// In en, this message translates to:
  /// **'on a dark surface, dramatically highlighted with directional light'**
  String get promptCatPerfumeScenario3;

  /// No description provided for @promptCatElectronicsName.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get promptCatElectronicsName;

  /// No description provided for @promptCatElectronicsScene.
  ///
  /// In en, this message translates to:
  /// **'A modern desk setup, minimalist décor, tidy cables, and soft office lighting'**
  String get promptCatElectronicsScene;

  /// No description provided for @promptCatElectronicsScenario1.
  ///
  /// In en, this message translates to:
  /// **'held in a person\'s hand, while in use'**
  String get promptCatElectronicsScenario1;

  /// No description provided for @promptCatElectronicsScenario2.
  ///
  /// In en, this message translates to:
  /// **'on a desk, alongside a laptop and a cup of coffee'**
  String get promptCatElectronicsScenario2;

  /// No description provided for @promptCatElectronicsScenario3.
  ///
  /// In en, this message translates to:
  /// **'displayed next to its box, with unboxed packaging'**
  String get promptCatElectronicsScenario3;

  /// No description provided for @promptCatFurnitureName.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get promptCatFurnitureName;

  /// No description provided for @promptCatFurnitureScene.
  ///
  /// In en, this message translates to:
  /// **'A warmly lit, modern living room, with natural light streaming through a large window'**
  String get promptCatFurnitureScene;

  /// No description provided for @promptCatFurnitureScenario1.
  ///
  /// In en, this message translates to:
  /// **'in the center of the room, harmonizing with other décor pieces'**
  String get promptCatFurnitureScenario1;

  /// No description provided for @promptCatFurnitureScenario2.
  ///
  /// In en, this message translates to:
  /// **'with a book and a plant placed on top'**
  String get promptCatFurnitureScenario2;

  /// No description provided for @promptCatFurnitureScenario3.
  ///
  /// In en, this message translates to:
  /// **'in evening light, within a warm atmosphere'**
  String get promptCatFurnitureScenario3;

  /// No description provided for @promptCatHomeDecorName.
  ///
  /// In en, this message translates to:
  /// **'Home Decor'**
  String get promptCatHomeDecorName;

  /// No description provided for @promptCatHomeDecorScene.
  ///
  /// In en, this message translates to:
  /// **'A minimalist shelf arrangement, natural textures (wood, linen), and soft daylight'**
  String get promptCatHomeDecorScene;

  /// No description provided for @promptCatHomeDecorScenario1.
  ///
  /// In en, this message translates to:
  /// **'on a shelf, alongside books and a candle'**
  String get promptCatHomeDecorScenario1;

  /// No description provided for @promptCatHomeDecorScenario2.
  ///
  /// In en, this message translates to:
  /// **'at the center of a table, with a floral arrangement'**
  String get promptCatHomeDecorScenario2;

  /// No description provided for @promptCatHomeDecorScenario3.
  ///
  /// In en, this message translates to:
  /// **'near a wall, with dramatic lighting and shadow play'**
  String get promptCatHomeDecorScenario3;

  /// No description provided for @promptCatKitchenName.
  ///
  /// In en, this message translates to:
  /// **'Kitchenware'**
  String get promptCatKitchenName;

  /// No description provided for @promptCatKitchenScene.
  ///
  /// In en, this message translates to:
  /// **'A modern kitchen counter, marble surface, with natural morning light from a window'**
  String get promptCatKitchenScene;

  /// No description provided for @promptCatKitchenScenario1.
  ///
  /// In en, this message translates to:
  /// **'arranged together with fresh ingredients (vegetables, fruit)'**
  String get promptCatKitchenScenario1;

  /// No description provided for @promptCatKitchenScenario2.
  ///
  /// In en, this message translates to:
  /// **'in use, held in a hand'**
  String get promptCatKitchenScenario2;

  /// No description provided for @promptCatKitchenScenario3.
  ///
  /// In en, this message translates to:
  /// **'alongside other kitchenware, on a tidy shelf'**
  String get promptCatKitchenScenario3;

  /// No description provided for @promptCatBabyName.
  ///
  /// In en, this message translates to:
  /// **'Baby & Kids'**
  String get promptCatBabyName;

  /// No description provided for @promptCatBabyScene.
  ///
  /// In en, this message translates to:
  /// **'A soft pastel-toned nursery, with toys and warm, comforting light'**
  String get promptCatBabyScene;

  /// No description provided for @promptCatBabyScenario1.
  ///
  /// In en, this message translates to:
  /// **'next to a baby, inside a crib'**
  String get promptCatBabyScenario1;

  /// No description provided for @promptCatBabyScenario2.
  ///
  /// In en, this message translates to:
  /// **'in a child\'s hand, while playing'**
  String get promptCatBabyScenario2;

  /// No description provided for @promptCatBabyScenario3.
  ///
  /// In en, this message translates to:
  /// **'arranged with other toys, on a rug'**
  String get promptCatBabyScenario3;

  /// No description provided for @promptCatSportsName.
  ///
  /// In en, this message translates to:
  /// **'Sports & Fitness'**
  String get promptCatSportsName;

  /// No description provided for @promptCatSportsScene.
  ///
  /// In en, this message translates to:
  /// **'A modern gym or outdoor training area, with energetic, dynamic lighting'**
  String get promptCatSportsScene;

  /// No description provided for @promptCatSportsScenario1.
  ///
  /// In en, this message translates to:
  /// **'in use while a person is working out'**
  String get promptCatSportsScenario1;

  /// No description provided for @promptCatSportsScenario2.
  ///
  /// In en, this message translates to:
  /// **'neatly placed on a yoga mat'**
  String get promptCatSportsScenario2;

  /// No description provided for @promptCatSportsScenario3.
  ///
  /// In en, this message translates to:
  /// **'next to a gym bag, in a pre-workout flat lay'**
  String get promptCatSportsScenario3;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
