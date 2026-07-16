import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.geceSiyahi,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Profil — Adım 20',
          style: TextStyle(color: AppColors.acikGri),
        ),
      ),
    );
  }
}