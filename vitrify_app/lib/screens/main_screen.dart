import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import 'theme_screen.dart';
import 'create_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ThemeScreen(),
    CreateScreen(),
    GalleryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.derinGri,
        selectedItemColor: AppColors.vitrifyMavisi,
        unselectedItemColor: AppColors.acikGri,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.palette_outlined),
            activeIcon: const Icon(Icons.palette),
            label: l10n.navTheme,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome),
            label: l10n.navCreate,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo_library_outlined),
            activeIcon: const Icon(Icons.photo_library),
            label: l10n.navGallery,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}