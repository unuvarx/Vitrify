import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/theme_settings.dart';
import '../services/storage_service.dart';
import '../widgets/app_alert.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final _storage = StorageService();

  final _scenePromptController = TextEditingController();
  final List<TextEditingController> _scenarioControllers = [];

  String _aspectRatio = '1:1';
  bool _isSaved = false;

  final List<String> _aspectRatios = ['1:1', '4:5', '9:16', '16:9'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _scenePromptController.dispose();
    for (final c in _scenarioControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Kayıtlı ayarları yükle
  void _loadSettings() {
    final settings = _storage.getThemeSettings();

    _scenePromptController.text = settings.scenePrompt;
    _aspectRatio = settings.aspectRatio;

    // Senaryo kontrolcülerini oluştur
    _scenarioControllers.clear();
    for (final scenario in settings.scenarios) {
      _scenarioControllers.add(TextEditingController(text: scenario));
    }

    // En az bir senaryo olsun
    if (_scenarioControllers.isEmpty) {
      _scenarioControllers.add(TextEditingController());
    }

    setState(() {});
  }

  // Senaryo ekle
  void _addScenario() {
    setState(() {
      _scenarioControllers.add(TextEditingController());
      _isSaved = false;
    });
  }

  // Senaryo sil
  void _removeScenario(int index) {
    if (_scenarioControllers.length <= 1) return; // en az 1 kalmalı

    setState(() {
      _scenarioControllers[index].dispose();
      _scenarioControllers.removeAt(index);
      _isSaved = false;
    });
  }

  // Kaydet
  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final scenarios = _scenarioControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (_scenePromptController.text.trim().isEmpty) {
      _showMessage(l10n.themeScenePromptRequired);
      return;
    }

    if (scenarios.isEmpty) {
      _showMessage(l10n.themeScenarioRequired);
      return;
    }

    final settings = ThemeSettings(
      scenePrompt: _scenePromptController.text.trim(),
      scenarios: scenarios,
      aspectRatio: _aspectRatio,
    );

    await _storage.saveThemeSettings(settings);

    setState(() => _isSaved = true);
    _showMessage(l10n.themeSaved);
  }

  void _showMessage(String message) {
    AppAlert.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeAppBarTitle),
        backgroundColor: AppColors.derinGri(context),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- MEKAN ----
            _sectionTitle(l10n.themeSceneTitle, l10n.themeSceneSubtitle),
            const SizedBox(height: 12),
            TextField(
              controller: _scenePromptController,
              maxLines: 4,
              onChanged: (_) => setState(() => _isSaved = false),
              decoration: InputDecoration(
                hintText: l10n.themeSceneHint,
                hintStyle: TextStyle(color: AppColors.acikGri(context), fontSize: 13),
              ),
            ),

            const SizedBox(height: 32),

            // ---- SENARYOLAR ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _sectionTitle(
                    l10n.themeScenariosTitle,
                    l10n.themeScenariosSubtitle,
                  ),
                ),
                IconButton(
                  onPressed: _addScenario,
                  icon: Icon(
                    Icons.add_circle,
                    color: AppColors.vitrifyMavisi(context),
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...List.generate(_scenarioControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _scenarioControllers[index],
                        onChanged: (_) => setState(() => _isSaved = false),
                        decoration: InputDecoration(
                          hintText: l10n.themeScenarioHint(index + 1),
                          hintStyle: TextStyle(
                            color: AppColors.acikGri(context),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    if (_scenarioControllers.length > 1)
                      IconButton(
                        onPressed: () => _removeScenario(index),
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: AppColors.acikGri(context),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // ---- ASPECT RATIO ----
            _sectionTitle(l10n.themeAspectRatioTitle, l10n.themeAspectRatioSubtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _aspectRatios.map((ratio) {
                final isSelected = _aspectRatio == ratio;
                return ChoiceChip(
                  label: Text(ratio),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _aspectRatio = ratio;
                      _isSaved = false;
                    });
                  },
                  backgroundColor: AppColors.derinGri(context),
                  selectedColor: AppColors.vitrifyMavisi(context),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.safBeyaz(context) : AppColors.acikGri(context),
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // ---- KAYDET ----
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(_isSaved ? Icons.check : Icons.save_outlined),
                label: Text(_isSaved ? l10n.themeSavedButton : l10n.themeSaveButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSaved
                      ? AppColors.basariYesili(context)
                      : AppColors.vitrifyMavisi(context),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.safBeyaz(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppColors.acikGri(context)),
        ),
      ],
    );
  }
}