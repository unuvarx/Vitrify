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
  String get loginWrongCredentials => 'Incorrect email or password.';

  @override
  String get loginEmailInUse => 'This email is already in use.';

  @override
  String get loginWeakPassword =>
      'Password is too weak, must be at least 6 characters.';

  @override
  String get loginInvalidEmail => 'Invalid email address.';

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
  String get loginAppleSignIn => 'Sign in with Apple';

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
  String get createAiDisclaimerBanner =>
      'AI-generated images may alter text and brand logos on your product — please keep this in mind.';

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
  String get profilePurchasePending =>
      'Purchase completed — your credits will appear shortly.';

  @override
  String get profilePurchaseFailed => 'Purchase failed.';

  @override
  String profileCreditsSuffix(int credits) {
    return '$credits credits';
  }

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileDeleteAccount => 'Delete My Account';

  @override
  String get profileDeleteAccountConfirmTitle =>
      'Are you sure you want to delete your account?';

  @override
  String get profileDeleteAccountConfirmMessage =>
      'This cannot be undone. Your account, credits, and generation history will be permanently deleted.';

  @override
  String get profileDeleteAccountCancel => 'Cancel';

  @override
  String get profileDeleteAccountConfirmButton => 'Delete My Account';

  @override
  String get profileDeleteAccountFailed =>
      'Could not delete account. Please try again.';

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
      'A clean, elegant studio setting in neutral tones, with a subtle fabric drape and a minimal jewelry stand, lit with soft professional lighting';

  @override
  String get promptCatJewelryScenario1 =>
      'on a white jewelry stand, the whole product in frame, not shot too close';

  @override
  String get promptCatJewelryScenario2 =>
      'next to a simple jewelry box, in a wide desktop flat lay';

  @override
  String get promptCatJewelryScenario3 =>
      'highlighted with soft side lighting, next to a small decorative object, the whole product visible';

  @override
  String get promptCatWatchName => 'Watches';

  @override
  String get promptCatWatchScene =>
      'A clean, elegant studio desk setup in light gray-white tones, with a slim watch stand and a minimal decor piece, lit with soft professional lighting';

  @override
  String get promptCatWatchScenario1 =>
      'on a watch stand, dial facing forward, the whole product in frame';

  @override
  String get promptCatWatchScenario2 =>
      'on a desk at a slight angle, next to a simple notebook, not shot too close';

  @override
  String get promptCatWatchScenario3 =>
      'displayed inside a slim display case, in a wide frame';

  @override
  String get promptCatGlassesName => 'Glasses';

  @override
  String get promptCatGlassesScene =>
      'A clean, modern studio desk setup in neutral tones, with a simple book and a minimal decor piece, lit with soft lighting';

  @override
  String get promptCatGlassesScenario1 =>
      'folded neatly, next to a simple book, the whole product in a wide frame';

  @override
  String get promptCatGlassesScenario2 =>
      'standing upright on a slim display stand, not shot too close';

  @override
  String get promptCatGlassesScenario3 =>
      'slightly open on a desk, shown in side profile, the whole product visible';

  @override
  String get promptCatTshirtName => 'T-Shirts & Tops';

  @override
  String get promptCatTshirtScene =>
      'A clean, modern studio setting with a plain neutral-toned backdrop, lit with soft professional lighting';

  @override
  String get promptCatTshirtScenario1 =>
      'on a mannequin, straight-on front view, the whole product in frame';

  @override
  String get promptCatTshirtScenario2 =>
      'hanging on a wooden clothing rail, in a wide frame, not shot too close';

  @override
  String get promptCatTshirtScenario3 =>
      'neatly folded next to a simple decor piece, on a table';

  @override
  String get promptCatPantsName => 'Pants';

  @override
  String get promptCatPantsScene =>
      'A clean, modern studio setting with a plain neutral-toned backdrop, lit with soft professional lighting';

  @override
  String get promptCatPantsScenario1 =>
      'on a mannequin, straight-on front view, the whole product in frame';

  @override
  String get promptCatPantsScenario2 =>
      'hanging on a wooden clothing rail, in a wide frame';

  @override
  String get promptCatPantsScenario3 => 'neatly folded on a simple table';

  @override
  String get promptCatJacketName => 'Jackets & Coats';

  @override
  String get promptCatJacketScene =>
      'A clean, modern studio setting with a plain neutral-toned backdrop, lit with soft professional lighting';

  @override
  String get promptCatJacketScenario1 =>
      'on a mannequin, straight-on front view, the whole product in frame';

  @override
  String get promptCatJacketScenario2 =>
      'hanging neatly on a wooden or metal clothing rail, in a simple store-style arrangement';

  @override
  String get promptCatJacketScenario3 =>
      'at a slight 3/4 angle showing the collar and details, with the whole product still in frame';

  @override
  String get promptCatBagName => 'Bags';

  @override
  String get promptCatBagScene =>
      'A clean, elegant studio desk setup in neutral tones, with a minimal decor piece, lit with soft lighting';

  @override
  String get promptCatBagScenario1 =>
      'standing upright, centered on its own base, the whole product in a wide frame';

  @override
  String get promptCatBagScenario2 =>
      'shown in side profile with the handle clearly visible, not shot too close';

  @override
  String get promptCatBagScenario3 =>
      'on a chair or stool, in a simple arrangement, wide frame';

  @override
  String get promptCatShoesName => 'Shoes';

  @override
  String get promptCatShoesScene =>
      'A clean, modern studio backdrop in neutral tones, lit with soft, crisp professional lighting';

  @override
  String get promptCatShoesScenario1 =>
      'single shoe in side profile, the whole product in frame, not shot too close';

  @override
  String get promptCatShoesScenario2 =>
      'as a pair, next to their box, in a simple arrangement';

  @override
  String get promptCatShoesScenario3 =>
      'shown from a slight overhead angle, in a wide frame';

  @override
  String get promptCatCosmeticsName => 'Cosmetics & Skincare';

  @override
  String get promptCatCosmeticsScene =>
      'A clean bathroom/spa-style arrangement in neutral tones, with a simple towel and a minimal decor piece, lit with soft lighting';

  @override
  String get promptCatCosmeticsScenario1 =>
      'standing upright next to a simple decor piece, the whole product in frame, not shot too close';

  @override
  String get promptCatCosmeticsScenario2 =>
      'lit with soft side lighting, in a wide frame';

  @override
  String get promptCatCosmeticsScenario3 =>
      'cap closed, in a simple table arrangement';

  @override
  String get promptCatPerfumeName => 'Perfume';

  @override
  String get promptCatPerfumeScene =>
      'An elegant, simple vanity table setup in neutral tones, with a small decor piece (flowers or fabric), lit with soft lighting';

  @override
  String get promptCatPerfumeScenario1 =>
      'bottle upright, the whole product in a wide frame, not shot too close';

  @override
  String get promptCatPerfumeScenario2 =>
      'on a subtly reflective surface, next to a simple decor piece';

  @override
  String get promptCatPerfumeScenario3 =>
      'lit with soft side lighting, in a wide frame';

  @override
  String get promptCatElectronicsName => 'Electronics';

  @override
  String get promptCatElectronicsScene =>
      'A modern, clean desk setup, minimalist décor, tidy cables, lit with soft professional lighting';

  @override
  String get promptCatElectronicsScenario1 =>
      'on a desk, straight-on front view, the whole product in frame';

  @override
  String get promptCatElectronicsScenario2 =>
      'next to a simple decor piece (notebook, cup), shown at a slight angle';

  @override
  String get promptCatElectronicsScenario3 =>
      'displayed next to its box, in a wide frame';

  @override
  String get promptCatFurnitureName => 'Furniture';

  @override
  String get promptCatFurnitureScene =>
      'A warm, simple room setting in neutral tones, with natural light and minimal decor pieces';

  @override
  String get promptCatFurnitureScenario1 =>
      'in the room, harmonizing with other simple décor pieces, the whole product in frame';

  @override
  String get promptCatFurnitureScenario2 =>
      'shown at a slight corner angle, in a wide frame';

  @override
  String get promptCatFurnitureScenario3 =>
      'side profile view, in a simple arrangement';

  @override
  String get promptCatHomeDecorName => 'Home Decor';

  @override
  String get promptCatHomeDecorScene =>
      'A simple shelf/table arrangement, natural textures (wood, linen), with minimal decor pieces, lit with soft lighting';

  @override
  String get promptCatHomeDecorScenario1 =>
      'on a shelf, next to a simple decor piece (book, candle)';

  @override
  String get promptCatHomeDecorScenario2 =>
      'at the center of a table, with a simple floral arrangement, wide frame';

  @override
  String get promptCatHomeDecorScenario3 =>
      'lit with soft side lighting, the whole product in frame';

  @override
  String get promptCatKitchenName => 'Kitchenware';

  @override
  String get promptCatKitchenScene =>
      'A modern, clean kitchen countertop setup in neutral tones, lit with soft natural light';

  @override
  String get promptCatKitchenScenario1 =>
      'on the counter, next to a few simple ingredients (fruit/vegetables), the whole product in frame';

  @override
  String get promptCatKitchenScenario2 =>
      'shown from a slight overhead angle, in a wide frame';

  @override
  String get promptCatKitchenScenario3 =>
      'alongside other simple kitchenware, on a tidy shelf';

  @override
  String get promptCatBabyName => 'Baby & Kids';

  @override
  String get promptCatBabyScene =>
      'A soft pastel-toned nursery setup, with toys and minimal decor pieces, lit with warm, reassuring light';

  @override
  String get promptCatBabyScenario1 =>
      'on a simple shelf, next to a couple of toys, the whole product in frame';

  @override
  String get promptCatBabyScenario2 =>
      'on a slightly raised platform, in a wide frame';

  @override
  String get promptCatBabyScenario3 =>
      'on a rug, in a neat, simple arrangement';

  @override
  String get promptCatSportsName => 'Sports & Fitness';

  @override
  String get promptCatSportsScene =>
      'A modern, clean training area setup in neutral tones, lit with energetic yet clean professional lighting';

  @override
  String get promptCatSportsScenario1 =>
      'on a yoga mat, neatly arranged, the whole product in frame';

  @override
  String get promptCatSportsScenario2 =>
      'next to a gym bag, in a simple arrangement';

  @override
  String get promptCatSportsScenario3 =>
      'shown at a slight angle, in a wide frame';
}
