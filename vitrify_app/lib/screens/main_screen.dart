import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../widgets/refreshable.dart';
import 'theme_screen.dart';
import 'create_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';
import 'suggested_prompts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int _createIndex = 2;
  static const double _barHeight = 64;
  static const double _fabSize = 56;
  static const double _fabRingWidth = 8;
  static const double _fabOuterSize = _fabSize + _fabRingWidth * 2;

  int _currentIndex = 0;

  final _createKey = GlobalKey<State<CreateScreen>>();
  final _galleryKey = GlobalKey<State<GalleryScreen>>();
  final _profileKey = GlobalKey<State<ProfileScreen>>();

  late final List<Widget> _screens = [
    const ThemeScreen(),
    GalleryScreen(key: _galleryKey),
    CreateScreen(key: _createKey),
    ProfileScreen(key: _profileKey),
    const SuggestedPromptsScreen(),
  ];

  // Tema ve Öneriler sekmelerine dokunmuyoruz (sunucu verisi yok). Diğerlerinin
  // canlı sunucu verisi olduğu için her seçildiğinde tazeliyoruz — Oluştur'da
  // bu sadece kredi sayısını günceller, devam eden bir üretimi bozmaz.
  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);

    final refreshable = switch (index) {
      1 => _galleryKey.currentState as Refreshable?,
      _createIndex => _createKey.currentState as Refreshable?,
      3 => _profileKey.currentState as Refreshable?,
      _ => null,
    };
    refreshable?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SizedBox(
        height: _barHeight + bottomInset,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Alt bar — ortadaki butonun yarısı bunun üstüne taşacak
            Container(
              color: AppColors.derinGri(context),
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SizedBox(
                height: _barHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _navItem(
                            icon: Icons.palette_outlined,
                            activeIcon: Icons.palette,
                            label: l10n.navTheme,
                            index: 0,
                          ),
                          _navItem(
                            icon: Icons.photo_library_outlined,
                            activeIcon: Icons.photo_library,
                            label: l10n.navGallery,
                            index: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _fabOuterSize),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _navItem(
                            icon: Icons.person_outline,
                            activeIcon: Icons.person,
                            label: l10n.navProfile,
                            index: 3,
                          ),
                          _navItem(
                            icon: Icons.tips_and_updates_outlined,
                            activeIcon: Icons.tips_and_updates,
                            label: l10n.navPrompts,
                            index: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Ortadaki Oluştur butonu — tam yuvarlak, etrafında bar rengiyle
            // aynı renkte bir halka (padding) var; yarısı barın üstüne taşar
            Positioned(
              top: -(_fabOuterSize / 3),
              child: Container(
                width: _fabOuterSize,
                height: _fabOuterSize,
                decoration: BoxDecoration(
                  color: AppColors.derinGri(context),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Material(
                  color: AppColors.vitrifyMavisi(context),
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _onTabTapped(_createIndex),
                    child: SizedBox(
                      width: _fabSize,
                      height: _fabSize,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 26,
                        semanticLabel: l10n.navCreate,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.vitrifyMavisi(context) : AppColors.acikGri(context);

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10.5, color: color)),
          ],
        ),
      ),
    );
  }
}
