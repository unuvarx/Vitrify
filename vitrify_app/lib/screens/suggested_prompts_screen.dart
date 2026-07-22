import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/theme_settings.dart';
import '../services/storage_service.dart';
import '../widgets/app_alert.dart';

class SuggestedPromptsScreen extends StatelessWidget {
  const SuggestedPromptsScreen({super.key});

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    AppAlert.show(context, AppLocalizations.of(context)!.promptsCopied);
  }

  // Kategorinin mekanını ve TÜM senaryolarını kopyala-yapıştıra gerek
  // kalmadan doğrudan Tema ayarlarına kaydeder — Oluştur sekmesi bu
  // ayarları kullanır
  void _useCategory(BuildContext context, _CategoryPrompts data) {
    final storage = StorageService();
    final current = storage.getThemeSettings();
    storage.saveThemeSettings(ThemeSettings(
      scenePrompt: data.scene,
      scenarios: data.scenarios,
      aspectRatio: current.aspectRatio,
    ));
    AppAlert.show(context, AppLocalizations.of(context)!.promptsApplied);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final categories = [
      _CategoryPrompts(
        icon: Icons.diamond_outlined,
        name: l10n.promptCatJewelryName,
        scene: l10n.promptCatJewelryScene,
        scenarios: [
          l10n.promptCatJewelryScenario1,
          l10n.promptCatJewelryScenario2,
          l10n.promptCatJewelryScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.watch_outlined,
        name: l10n.promptCatWatchName,
        scene: l10n.promptCatWatchScene,
        scenarios: [
          l10n.promptCatWatchScenario1,
          l10n.promptCatWatchScenario2,
          l10n.promptCatWatchScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.visibility_outlined,
        name: l10n.promptCatGlassesName,
        scene: l10n.promptCatGlassesScene,
        scenarios: [
          l10n.promptCatGlassesScenario1,
          l10n.promptCatGlassesScenario2,
          l10n.promptCatGlassesScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.checkroom_outlined,
        name: l10n.promptCatTshirtName,
        scene: l10n.promptCatTshirtScene,
        scenarios: [
          l10n.promptCatTshirtScenario1,
          l10n.promptCatTshirtScenario2,
          l10n.promptCatTshirtScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.straighten_outlined,
        name: l10n.promptCatPantsName,
        scene: l10n.promptCatPantsScene,
        scenarios: [
          l10n.promptCatPantsScenario1,
          l10n.promptCatPantsScenario2,
          l10n.promptCatPantsScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.dry_cleaning_outlined,
        name: l10n.promptCatJacketName,
        scene: l10n.promptCatJacketScene,
        scenarios: [
          l10n.promptCatJacketScenario1,
          l10n.promptCatJacketScenario2,
          l10n.promptCatJacketScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.shopping_bag_outlined,
        name: l10n.promptCatBagName,
        scene: l10n.promptCatBagScene,
        scenarios: [
          l10n.promptCatBagScenario1,
          l10n.promptCatBagScenario2,
          l10n.promptCatBagScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.hiking_outlined,
        name: l10n.promptCatShoesName,
        scene: l10n.promptCatShoesScene,
        scenarios: [
          l10n.promptCatShoesScenario1,
          l10n.promptCatShoesScenario2,
          l10n.promptCatShoesScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.spa_outlined,
        name: l10n.promptCatCosmeticsName,
        scene: l10n.promptCatCosmeticsScene,
        scenarios: [
          l10n.promptCatCosmeticsScenario1,
          l10n.promptCatCosmeticsScenario2,
          l10n.promptCatCosmeticsScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.opacity_outlined,
        name: l10n.promptCatPerfumeName,
        scene: l10n.promptCatPerfumeScene,
        scenarios: [
          l10n.promptCatPerfumeScenario1,
          l10n.promptCatPerfumeScenario2,
          l10n.promptCatPerfumeScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.devices_outlined,
        name: l10n.promptCatElectronicsName,
        scene: l10n.promptCatElectronicsScene,
        scenarios: [
          l10n.promptCatElectronicsScenario1,
          l10n.promptCatElectronicsScenario2,
          l10n.promptCatElectronicsScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.weekend_outlined,
        name: l10n.promptCatFurnitureName,
        scene: l10n.promptCatFurnitureScene,
        scenarios: [
          l10n.promptCatFurnitureScenario1,
          l10n.promptCatFurnitureScenario2,
          l10n.promptCatFurnitureScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.local_florist_outlined,
        name: l10n.promptCatHomeDecorName,
        scene: l10n.promptCatHomeDecorScene,
        scenarios: [
          l10n.promptCatHomeDecorScenario1,
          l10n.promptCatHomeDecorScenario2,
          l10n.promptCatHomeDecorScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.kitchen_outlined,
        name: l10n.promptCatKitchenName,
        scene: l10n.promptCatKitchenScene,
        scenarios: [
          l10n.promptCatKitchenScenario1,
          l10n.promptCatKitchenScenario2,
          l10n.promptCatKitchenScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.child_friendly_outlined,
        name: l10n.promptCatBabyName,
        scene: l10n.promptCatBabyScene,
        scenarios: [
          l10n.promptCatBabyScenario1,
          l10n.promptCatBabyScenario2,
          l10n.promptCatBabyScenario3,
        ],
      ),
      _CategoryPrompts(
        icon: Icons.fitness_center_outlined,
        name: l10n.promptCatSportsName,
        scene: l10n.promptCatSportsScene,
        scenarios: [
          l10n.promptCatSportsScenario1,
          l10n.promptCatSportsScenario2,
          l10n.promptCatSportsScenario3,
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.promptsAppBarTitle),
        backgroundColor: AppColors.derinGri(context),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        itemBuilder: (context, index) => _CategoryCard(
          data: categories[index],
          onCopy: _copy,
          onUseCategory: _useCategory,
        ),
      ),
    );
  }
}

class _CategoryPrompts {
  final IconData icon;
  final String name;
  final String scene;
  final List<String> scenarios;

  _CategoryPrompts({
    required this.icon,
    required this.name,
    required this.scene,
    required this.scenarios,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategoryPrompts data;
  final void Function(BuildContext, String) onCopy;
  final void Function(BuildContext, _CategoryPrompts) onUseCategory;

  const _CategoryCard({
    required this.data,
    required this.onCopy,
    required this.onUseCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.derinGri(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, color: AppColors.vitrifyMavisi(context), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.safBeyaz(context),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onUseCategory(context, data),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 22,
                    color: AppColors.basariYesili(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.promptsSceneLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.acikGri(context),
            ),
          ),
          const SizedBox(height: 4),
          _PromptRow(text: data.scene, onTap: () => onCopy(context, data.scene)),
          const SizedBox(height: 12),
          Text(
            l10n.promptsScenarioLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.acikGri(context),
            ),
          ),
          const SizedBox(height: 4),
          ...data.scenarios.map(
            (s) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _PromptRow(text: s, onTap: () => onCopy(context, s)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromptRow extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PromptRow({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.geceSiyahi(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.safBeyaz(context), fontSize: 13),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.copy_outlined,
                size: 18,
                color: AppColors.vitrifyMavisi(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
