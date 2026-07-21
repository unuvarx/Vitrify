import 'dart:io';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/gallery_service.dart';
import '../widgets/app_alert.dart';
import '../widgets/refreshable.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> implements Refreshable {
  final _gallery = GalleryService();

  List<File> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  // MainScreen bu sekmeye her geçildiğinde çağırır (IndexedStack initState'i
  // tekrar çalıştırmadığı için başka sekmede üretilen görseller görünmezdi)
  @override
  Future<void> refresh() => _loadImages();

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);

    final images = await _gallery.listGeneratedImages();

    if (!mounted) return;
    setState(() {
      _images = images;
      _isLoading = false;
    });
  }

  Future<void> _confirmDelete(File file) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.derinGri(context),
        title: Text(
          l10n.galleryDeleteTitle,
          style: TextStyle(color: AppColors.safBeyaz(context)),
        ),
        content: Text(
          l10n.galleryDeleteContent,
          style: TextStyle(color: AppColors.acikGri(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.galleryCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.galleryDelete,
              style: TextStyle(color: AppColors.hataKirmizi(context)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _gallery.deleteImage(file);
    if (!mounted) return;
    setState(() => _images.remove(file));
  }

  Future<void> _saveToDevice(File file) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _gallery.saveToDeviceGallery(file);
    if (!mounted) return;

    final message = switch (result) {
      SaveToGalleryResult.success => l10n.gallerySavedToDevice,
      SaveToGalleryResult.permissionDenied => l10n.galleryPermissionDenied,
      SaveToGalleryResult.saveFailed => l10n.galleryDeviceSaveFailed,
    };
    _showMessage(message);
  }

  void _showMessage(String message) {
    AppAlert.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.galleryAppBarTitle),
        backgroundColor: AppColors.derinGri(context),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadImages,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(color: AppColors.vitrifyMavisi(context)),
            )
          : _images.isEmpty
              ? Center(
                  child: Text(
                    l10n.galleryEmpty,
                    style: TextStyle(color: AppColors.acikGri(context)),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final file = _images[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(file, fit: BoxFit.cover),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: _iconButton(
                              icon: Icons.delete,
                              onTap: () => _confirmDelete(file),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: _iconButton(
                              icon: Icons.download,
                              onTap: () => _saveToDevice(file),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  // Not: bu ikonlar her zaman fotoğrafın üstünde, sabit yarı-saydam siyah bir
  // daire üzerinde duruyor — tema (açık/koyu) burada uygulanmaz, ikon rengi
  // sabit beyaz olmalı (yoksa açık modda ikon arka planla neredeyse aynı
  // renk olup görünmez oluyordu).
  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
