// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get genericErrorMessage => 'Something went wrong. Please try again.';

  @override
  String get commonOk => 'OK';

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
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginEnterEmailFirst => 'Enter your email address first.';

  @override
  String get loginPasswordResetSent =>
      'A password reset link has been sent to your email.';

  @override
  String get loginOrDivider => 'or';

  @override
  String get loginGoogleSignIn => 'Sign in with Google';

  @override
  String get navTheme => 'Theme';

  @override
  String get navCreate => 'Create';

  @override
  String get navGallery => 'Gallery';

  @override
  String get navProfile => 'Profile';

  @override
  String get navPrompts => 'Tips';

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
  String get createSafeToCloseApp =>
      'Generation has started. You can close the app now — we\'ll notify you when your images are ready.';

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
  String get galleryDeviceSaveFailed =>
      'Could not save the image to your device.';

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
  String get profilePurchaseCompletedButCreditsFailed =>
      'Purchase completed but credits could not be added. Please contact support.';

  @override
  String get profilePurchaseFailed => 'Purchase failed.';

  @override
  String profileCreditsSuffix(int credits) {
    return '$credits credits';
  }

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileThemeTitle => 'Appearance';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingPage1Title => 'Welcome to Vitrify';

  @override
  String get onboardingPage1Body =>
      'Turn product photos into professional scenes in seconds with AI.';

  @override
  String get onboardingPage2Title => '1. Create a Theme';

  @override
  String get onboardingPage2Body =>
      'Describe the scene and scenarios your products will be shown in — saved on your device.';

  @override
  String get onboardingPage3Title => '2. Generate';

  @override
  String get onboardingPage3Body =>
      'Upload your product photos and let AI generate images using your credits. Note: AI generation can introduce small differences in brand logos/text — we recommend reviewing generated images before use.';

  @override
  String get onboardingPage4Title => '3. View & Manage';

  @override
  String get onboardingPage4Body =>
      'View or save generated images in Gallery, and track your credits in Profile.';

  @override
  String get promptsAppBarTitle => 'Suggested Prompts';

  @override
  String get promptsCopied => 'Copied ✓';

  @override
  String get promptsApplied => 'Applied! You can use it from the Create tab.';

  @override
  String get promptsSceneLabel => 'Scene';

  @override
  String get promptsScenarioLabel => 'Scenarios';

  @override
  String get promptCatJewelryName => 'Jewelry';

  @override
  String get promptCatJewelryScene =>
      'A pure white studio backdrop, lit with soft, evenly diffused professional lighting and minimal shadow';

  @override
  String get promptCatJewelryScenario1 =>
      'centered symmetrically on a white platform';

  @override
  String get promptCatJewelryScenario2 =>
      'displayed on a slightly raised transparent stand';

  @override
  String get promptCatJewelryScenario3 =>
      'highlighted with soft side lighting and a subtle shadow';

  @override
  String get promptCatWatchName => 'Watches';

  @override
  String get promptCatWatchScene =>
      'A minimalist studio setting in neutral white-gray tones, lit with soft, balanced professional lighting';

  @override
  String get promptCatWatchScenario1 =>
      'on a white cube platform, dial facing forward';

  @override
  String get promptCatWatchScenario2 =>
      'at a slight angle, strap gently curved';

  @override
  String get promptCatWatchScenario3 =>
      'standing upright on a slim transparent stand';

  @override
  String get promptCatGlassesName => 'Glasses';

  @override
  String get promptCatGlassesScene =>
      'A pure white backdrop lit with soft, shadow-free studio lighting for a clean product display';

  @override
  String get promptCatGlassesScenario1 => 'folded neatly and symmetrically';

  @override
  String get promptCatGlassesScenario2 =>
      'slightly open, shown in side profile';

  @override
  String get promptCatGlassesScenario3 =>
      'standing upright on a slim display stand';

  @override
  String get promptCatTshirtName => 'T-Shirts & Tops';

  @override
  String get promptCatTshirtScene =>
      'A minimalist studio with a plain white backdrop, lit with soft, balanced professional lighting';

  @override
  String get promptCatTshirtScenario1 =>
      'on an invisible mannequin, straight-on symmetrical front view';

  @override
  String get promptCatTshirtScenario2 => 'neatly folded in an orderly stack';

  @override
  String get promptCatTshirtScenario3 =>
      'hanging flat and wrinkle-free on a slim hanger';

  @override
  String get promptCatPantsName => 'Pants';

  @override
  String get promptCatPantsScene =>
      'A minimalist studio with a plain white backdrop, lit with soft, balanced professional lighting';

  @override
  String get promptCatPantsScenario1 =>
      'on an invisible mannequin, straight-on front view';

  @override
  String get promptCatPantsScenario2 => 'neatly folded in an orderly stack';

  @override
  String get promptCatPantsScenario3 => 'hanging flat on a slim hanger';

  @override
  String get promptCatJacketName => 'Jackets & Coats';

  @override
  String get promptCatJacketScene =>
      'A minimalist studio with a plain white backdrop, lit with soft, balanced professional lighting';

  @override
  String get promptCatJacketScenario1 =>
      'on an invisible mannequin, straight-on front view';

  @override
  String get promptCatJacketScenario2 =>
      'hanging neatly on a wooden or metal hanger';

  @override
  String get promptCatJacketScenario3 =>
      'at a slight 3/4 angle, showing the collar and details';

  @override
  String get promptCatBagName => 'Bags';

  @override
  String get promptCatBagScene =>
      'A pure white backdrop lit with soft studio lighting for a clean product display';

  @override
  String get promptCatBagScenario1 =>
      'standing upright, centered on its own base';

  @override
  String get promptCatBagScenario2 =>
      'shown in side profile with the handle clearly visible';

  @override
  String get promptCatBagScenario3 =>
      'on a slightly raised platform, shown from a gentle overhead angle';

  @override
  String get promptCatShoesName => 'Shoes';

  @override
  String get promptCatShoesScene =>
      'A pure white backdrop lit with soft, crisp studio lighting for a clean product display';

  @override
  String get promptCatShoesScenario1 => 'single shoe in side profile, centered';

  @override
  String get promptCatShoesScenario2 => 'as a pair, shown at a 3/4 angle';

  @override
  String get promptCatShoesScenario3 => 'top-down view, arranged symmetrically';

  @override
  String get promptCatCosmeticsName => 'Cosmetics & Skincare';

  @override
  String get promptCatCosmeticsScene =>
      'A white marble or matte white surface, lit with soft, clean studio lighting';

  @override
  String get promptCatCosmeticsScenario1 =>
      'standing upright, centered and symmetrical';

  @override
  String get promptCatCosmeticsScenario2 =>
      'highlighted with soft side lighting and a subtle shadow';

  @override
  String get promptCatCosmeticsScenario3 =>
      'cap closed, arranged in a clean, minimal composition';

  @override
  String get promptCatPerfumeName => 'Perfume';

  @override
  String get promptCatPerfumeScene =>
      'A pure white backdrop lit with soft, crisp studio lighting for an elegant display';

  @override
  String get promptCatPerfumeScenario1 => 'bottle upright, perfectly centered';

  @override
  String get promptCatPerfumeScenario2 =>
      'on a subtly reflective white surface with a soft reflection';

  @override
  String get promptCatPerfumeScenario3 =>
      'lit with soft side lighting that reveals the glass texture';

  @override
  String get promptCatElectronicsName => 'Electronics';

  @override
  String get promptCatElectronicsScene =>
      'A minimalist gray-white studio backdrop, lit with soft, balanced professional lighting';

  @override
  String get promptCatElectronicsScenario1 =>
      'straight-on, symmetrical front view';

  @override
  String get promptCatElectronicsScenario2 => 'shown at a slight 3/4 angle';

  @override
  String get promptCatElectronicsScenario3 => 'top-down view, neatly arranged';

  @override
  String get promptCatFurnitureName => 'Furniture';

  @override
  String get promptCatFurnitureScene =>
      'A white/light-gray infinity backdrop, lit with soft, evenly diffused professional studio lighting';

  @override
  String get promptCatFurnitureScenario1 =>
      'straight-on, symmetrical front view';

  @override
  String get promptCatFurnitureScenario2 => 'shown at a slight corner angle';

  @override
  String get promptCatFurnitureScenario3 =>
      'side profile view with clean, sharp lines';

  @override
  String get promptCatHomeDecorName => 'Home Decor';

  @override
  String get promptCatHomeDecorScene =>
      'A clean white shelf/surface arrangement, lit with soft, balanced professional studio lighting';

  @override
  String get promptCatHomeDecorScenario1 =>
      'alone, centered in a clean, minimal display';

  @override
  String get promptCatHomeDecorScenario2 => 'on a slightly raised platform';

  @override
  String get promptCatHomeDecorScenario3 =>
      'highlighted with soft side lighting and a subtle shadow';

  @override
  String get promptCatKitchenName => 'Kitchenware';

  @override
  String get promptCatKitchenScene =>
      'A white marble-look countertop, lit with soft, crisp professional studio lighting';

  @override
  String get promptCatKitchenScenario1 => 'standing upright, centered';

  @override
  String get promptCatKitchenScenario2 => 'shown from a slight overhead angle';

  @override
  String get promptCatKitchenScenario3 =>
      'lit with side lighting that reveals texture and detail';

  @override
  String get promptCatBabyName => 'Baby & Kids';

  @override
  String get promptCatBabyScene =>
      'A soft white-pastel studio backdrop, lit with gentle, reassuring professional light';

  @override
  String get promptCatBabyScenario1 =>
      'alone, centered in a clean, minimal display';

  @override
  String get promptCatBabyScenario2 => 'on a slightly raised platform';

  @override
  String get promptCatBabyScenario3 => 'top-down view, neatly arranged';

  @override
  String get promptCatSportsName => 'Sports & Fitness';

  @override
  String get promptCatSportsScene =>
      'A minimalist white-gray studio backdrop, lit with energetic yet clean professional lighting';

  @override
  String get promptCatSportsScenario1 => 'straight-on, symmetrical front view';

  @override
  String get promptCatSportsScenario2 => 'shown at a slight 3/4 angle';

  @override
  String get promptCatSportsScenario3 => 'top-down view, neatly arranged';
}
