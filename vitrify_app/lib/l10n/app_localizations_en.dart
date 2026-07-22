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
      'Upload your product photos and let AI generate images using your credits.';

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
      'An elegant jewelry display on a velvet-textured surface, lit with soft, warm studio lighting';

  @override
  String get promptCatJewelryScenario1 =>
      'on a woman\'s wrist, in an elegant hand pose';

  @override
  String get promptCatJewelryScenario2 =>
      'inside an open jewelry box, resting on its velvet lining';

  @override
  String get promptCatJewelryScenario3 =>
      'on a glossy marble surface, lit with soft side lighting';

  @override
  String get promptCatWatchName => 'Watches';

  @override
  String get promptCatWatchScene =>
      'A minimalist, masculine studio setting on a dark wooden table, with sharp yet soft lighting';

  @override
  String get promptCatWatchScenario1 =>
      'on a man\'s wrist, alongside a shirt sleeve';

  @override
  String get promptCatWatchScenario2 =>
      'displayed inside a watch box, resting on its soft lining';

  @override
  String get promptCatWatchScenario3 =>
      'next to a leather notebook, in a desk-top flat lay';

  @override
  String get promptCatGlassesName => 'Glasses';

  @override
  String get promptCatGlassesScene =>
      'On a sunny café terrace, with natural daylight and a softly blurred city view in the background';

  @override
  String get promptCatGlassesScenario1 => 'on a person\'s face, while smiling';

  @override
  String get promptCatGlassesScenario2 =>
      'folded on a table, next to an open book';

  @override
  String get promptCatGlassesScenario3 =>
      'held in a hand, with an open sky in the background';

  @override
  String get promptCatTshirtName => 'T-Shirts & Tops';

  @override
  String get promptCatTshirtScene =>
      'A minimalist studio with a flat pastel-toned background and soft, balanced studio lighting';

  @override
  String get promptCatTshirtScenario1 =>
      'on a mannequin, in a straight-on front shot';

  @override
  String get promptCatTshirtScenario2 =>
      'worn by a person walking in a casual street setting';

  @override
  String get promptCatTshirtScenario3 =>
      'hanging on a wooden hanger, lit by natural window light';

  @override
  String get promptCatPantsName => 'Pants';

  @override
  String get promptCatPantsScene =>
      'A modern dressing room with warm wooden flooring and soft side lighting';

  @override
  String get promptCatPantsScenario1 =>
      'worn by a person, in a relaxed standing pose';

  @override
  String get promptCatPantsScenario2 => 'neatly folded on top of a chair';

  @override
  String get promptCatPantsScenario3 =>
      'displayed in a store window alongside other garments';

  @override
  String get promptCatJacketName => 'Jackets & Coats';

  @override
  String get promptCatJacketScene =>
      'An autumn atmosphere on a city street, with falling leaves and soft daylight';

  @override
  String get promptCatJacketScenario1 =>
      'worn by a person, in a natural pose captured mid-walk';

  @override
  String get promptCatJacketScenario2 =>
      'hanging on a wooden hanger in a store interior';

  @override
  String get promptCatJacketScenario3 =>
      'held over the shoulder with one hand, in a casual pose';

  @override
  String get promptCatBagName => 'Bags';

  @override
  String get promptCatBagScene =>
      'A stylish café table flat lay, with a cup of coffee and a magazine, in soft natural light';

  @override
  String get promptCatBagScenario1 =>
      'carried on a woman\'s shoulder, in a casual walking pose';

  @override
  String get promptCatBagScenario2 => 'casually placed on top of a chair';

  @override
  String get promptCatBagScenario3 =>
      'held by hand, captured while walking in the city';

  @override
  String get promptCatShoesName => 'Shoes';

  @override
  String get promptCatShoesScene =>
      'A street-style scene on a textured concrete surface, with hard yet warm daylight';

  @override
  String get promptCatShoesScenario1 =>
      'worn on a person\'s foot, captured mid-step';

  @override
  String get promptCatShoesScenario2 => 'displayed neatly next to its box';

  @override
  String get promptCatShoesScenario3 =>
      'on a staircase step, photographed with side lighting';

  @override
  String get promptCatCosmeticsName => 'Cosmetics & Skincare';

  @override
  String get promptCatCosmeticsScene =>
      'On a white marble countertop, in a soft and clean bathroom/spa atmosphere, lit with natural light';

  @override
  String get promptCatCosmeticsScenario1 =>
      'arranged next to green leaves and a towel';

  @override
  String get promptCatCosmeticsScenario2 =>
      'held in a woman\'s hand, while being applied to skin';

  @override
  String get promptCatCosmeticsScenario3 =>
      'with water droplets, light reflecting off the product';

  @override
  String get promptCatPerfumeName => 'Perfume';

  @override
  String get promptCatPerfumeScene =>
      'On an elegant vanity table, in front of a gold-detailed mirror, lit with evening light';

  @override
  String get promptCatPerfumeScenario1 =>
      'on a silk fabric, next to fresh flowers';

  @override
  String get promptCatPerfumeScenario2 =>
      'held in a woman\'s hand, while spraying it on';

  @override
  String get promptCatPerfumeScenario3 =>
      'on a dark surface, dramatically highlighted with directional light';

  @override
  String get promptCatElectronicsName => 'Electronics';

  @override
  String get promptCatElectronicsScene =>
      'A modern desk setup, minimalist décor, tidy cables, and soft office lighting';

  @override
  String get promptCatElectronicsScenario1 =>
      'held in a person\'s hand, while in use';

  @override
  String get promptCatElectronicsScenario2 =>
      'on a desk, alongside a laptop and a cup of coffee';

  @override
  String get promptCatElectronicsScenario3 =>
      'displayed next to its box, with unboxed packaging';

  @override
  String get promptCatFurnitureName => 'Furniture';

  @override
  String get promptCatFurnitureScene =>
      'A warmly lit, modern living room, with natural light streaming through a large window';

  @override
  String get promptCatFurnitureScenario1 =>
      'in the center of the room, harmonizing with other décor pieces';

  @override
  String get promptCatFurnitureScenario2 =>
      'with a book and a plant placed on top';

  @override
  String get promptCatFurnitureScenario3 =>
      'in evening light, within a warm atmosphere';

  @override
  String get promptCatHomeDecorName => 'Home Decor';

  @override
  String get promptCatHomeDecorScene =>
      'A minimalist shelf arrangement, natural textures (wood, linen), and soft daylight';

  @override
  String get promptCatHomeDecorScenario1 =>
      'on a shelf, alongside books and a candle';

  @override
  String get promptCatHomeDecorScenario2 =>
      'at the center of a table, with a floral arrangement';

  @override
  String get promptCatHomeDecorScenario3 =>
      'near a wall, with dramatic lighting and shadow play';

  @override
  String get promptCatKitchenName => 'Kitchenware';

  @override
  String get promptCatKitchenScene =>
      'A modern kitchen counter, marble surface, with natural morning light from a window';

  @override
  String get promptCatKitchenScenario1 =>
      'arranged together with fresh ingredients (vegetables, fruit)';

  @override
  String get promptCatKitchenScenario2 => 'in use, held in a hand';

  @override
  String get promptCatKitchenScenario3 =>
      'alongside other kitchenware, on a tidy shelf';

  @override
  String get promptCatBabyName => 'Baby & Kids';

  @override
  String get promptCatBabyScene =>
      'A soft pastel-toned nursery, with toys and warm, comforting light';

  @override
  String get promptCatBabyScenario1 => 'next to a baby, inside a crib';

  @override
  String get promptCatBabyScenario2 => 'in a child\'s hand, while playing';

  @override
  String get promptCatBabyScenario3 => 'arranged with other toys, on a rug';

  @override
  String get promptCatSportsName => 'Sports & Fitness';

  @override
  String get promptCatSportsScene =>
      'A modern gym or outdoor training area, with energetic, dynamic lighting';

  @override
  String get promptCatSportsScenario1 => 'in use while a person is working out';

  @override
  String get promptCatSportsScenario2 => 'neatly placed on a yoga mat';

  @override
  String get promptCatSportsScenario3 =>
      'next to a gym bag, in a pre-workout flat lay';

  @override
  String get promptCatCarsName => 'Cars';

  @override
  String get promptCatCarsScene =>
      'A realistic, clean vehicle presentation suited for a used-car/dealership listing, with balanced, natural lighting';

  @override
  String get promptCatCarsScenario1 =>
      'in a modern showroom, on a glossy, clean floor';

  @override
  String get promptCatCarsScenario2 =>
      'in a wide, empty paved lot outside the city, in daylight';

  @override
  String get promptCatCarsScenario3 =>
      'in front of a modern building\'s glass facade, in daylight';

  @override
  String get promptCatCarsScenario4 =>
      'in an indoor/underground parking garage, with even lighting';

  @override
  String get promptCatCarsScenario5 =>
      'at a car wash, freshly washed with a glistening body';

  @override
  String get promptCatCarsScenario6 =>
      'against a plain gray studio background, with soft, balanced studio lighting';

  @override
  String get promptCatCarsScenario7 =>
      'on a home\'s paved driveway, in daylight';

  @override
  String get promptCatCarsScenario8 =>
      'in a dealership\'s display area, with other cars gently blurred in the background';

  @override
  String get promptCatCarsScenario9 =>
      'on a quiet, empty road at sunset, in warm, soft light';
}
