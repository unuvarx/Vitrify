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
