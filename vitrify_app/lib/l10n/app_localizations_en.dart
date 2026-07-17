// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String genericErrorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get loginEmailPasswordRequired => 'Email and password are required.';

  @override
  String get loginEmailHint => 'Email';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginSignUpButton => 'Sign Up';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get loginSwitchToSignIn => 'Already have an account? Sign in';

  @override
  String get loginSwitchToSignUp => 'Don\'t have an account? Sign up';

  @override
  String loginCreditsLabel(int credits) {
    return 'Credits: $credits';
  }

  @override
  String get navTheme => 'Theme';

  @override
  String get navCreate => 'Create';

  @override
  String get navGallery => 'Gallery';

  @override
  String get navProfile => 'Profile';

  @override
  String get themeAppBarTitle => 'Theme';

  @override
  String get themeSceneTitle => 'Scene';

  @override
  String get themeSceneSubtitle =>
      'Describe the setting your products will be showcased in';

  @override
  String get themeSceneHint =>
      'E.g.: Around 9 AM, with the sun beautifully lighting the sea and beach, surrounded by islands';

  @override
  String get themeScenariosTitle => 'Scenarios';

  @override
  String get themeScenariosSubtitle =>
      'A separate image is generated for each scenario';

  @override
  String themeScenarioHint(int index) {
    return 'Scenario $index — E.g.: worn on a woman\'s wrist';
  }

  @override
  String get themeAspectRatioTitle => 'Image Ratio';

  @override
  String get themeAspectRatioSubtitle => 'Aspect ratio of the generated images';

  @override
  String get themeScenePromptRequired => 'A scene description is required.';

  @override
  String get themeScenarioRequired => 'At least one scenario is required.';

  @override
  String get themeSaved => 'Theme saved ✓';

  @override
  String get themeSaveButton => 'Save';

  @override
  String get themeSavedButton => 'Saved';

  @override
  String get createAppBarTitle => 'Create';

  @override
  String get createFillThemeFirst => 'Please fill in the Theme page first.';

  @override
  String get createSelectAtLeastOneImage =>
      'Select at least one product image.';

  @override
  String createInsufficientCredits(int required, int available) {
    return 'Insufficient credits. Required: $required, Available: $available';
  }

  @override
  String createSomeFailed(int count) {
    return '$count image(s) failed.';
  }

  @override
  String get createTimeout => 'The process took too long. Please try again.';

  @override
  String get createProductImagesTitle => 'Product Images';

  @override
  String get createSelectImages => 'Select Images';

  @override
  String createImagesSelected(int count) {
    return '$count image(s) selected';
  }

  @override
  String get createSubmitting => 'Submitting...';

  @override
  String get createGenerateButton => 'Generate';

  @override
  String get createGenerating => 'Generating...';

  @override
  String get createCompleted => 'Completed 🎉';

  @override
  String get createGeneratedImagesTitle => 'Generated Images';

  @override
  String get galleryAppBarTitle => 'Gallery';

  @override
  String get galleryDeleteTitle => 'Delete image';

  @override
  String get galleryDeleteContent =>
      'This image will be permanently deleted from your device.';

  @override
  String get galleryCancel => 'Cancel';

  @override
  String get galleryDelete => 'Delete';

  @override
  String get gallerySavedToDevice => 'Image saved to device gallery.';

  @override
  String get galleryPermissionDenied => 'Gallery permission was denied.';

  @override
  String get galleryEmpty => 'No generated images yet.';

  @override
  String get profileAppBarTitle => 'Profile';

  @override
  String get profileCreditsRemaining => 'Remaining Credits';

  @override
  String get profileBuyCreditsTitle => 'Buy Credits';

  @override
  String get profileBuyCreditsSubtitle => 'Add credits to generate more images';

  @override
  String get profileNoPackages =>
      'No packages available for purchase right now.';

  @override
  String get profilePackagesLoadError =>
      'Purchase packages could not be loaded right now.';

  @override
  String profileCreditsAdded(int credits) {
    return '$credits credits added ✓';
  }

  @override
  String profilePurchaseCompletedButCreditsFailed(String error) {
    return 'Purchase completed but credits could not be added: $error';
  }

  @override
  String get profilePurchaseFailed => 'Purchase failed.';

  @override
  String profileCreditsSuffix(int credits) {
    return '$credits credits';
  }

  @override
  String get profileSignOut => 'Sign Out';
}
