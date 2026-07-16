import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri'),
        backgroundColor: AppColors.geceSiyahi,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Galeri — Adım 19',
          style: TextStyle(color: AppColors.acikGri),
        ),
      ),
    );
  }
}