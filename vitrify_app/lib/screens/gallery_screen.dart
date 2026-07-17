import 'dart:io';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/gallery_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _gallery = GalleryService();

  List<File> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

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
        backgroundColor: AppColors.derinGri,
        title: Text(
          l10n.galleryDeleteTitle,
          style: const TextStyle(color: AppColors.safBeyaz),
        ),
        content: Text(
          l10n.galleryDeleteContent,
          style: const TextStyle(color: AppColors.acikGri),
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
              style: const TextStyle(color: AppColors.hataKirmizi),
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
    final success = await _gallery.saveToDeviceGallery(file);
    if (!mounted) return;

    _showMessage(
      success ? l10n.gallerySavedToDevice : l10n.galleryPermissionDenied,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.derinGri,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.galleryAppBarTitle),
        backgroundColor: AppColors.geceSiyahi,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadImages,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.vitrifyMavisi),
            )
          : _images.isEmpty
              ? Center(
                  child: Text(
                    l10n.galleryEmpty,
                    style: const TextStyle(color: AppColors.acikGri),
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
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(file, fit: BoxFit.cover),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: _iconButton(
                              icon: Icons.delete_outline,
                              onTap: () => _confirmDelete(file),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: _iconButton(
                              icon: Icons.download_outlined,
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

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.safBeyaz),
      ),
    );
  }
}
