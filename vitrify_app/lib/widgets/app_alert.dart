import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';

// Tüm ekranlarda kısa bilgi/hata mesajları için ortak, tema-duyarlı alert.
// SnackBar yerine bunu kullanıyoruz — SnackBar'ın varsayılan metin rengi açık
// temada arka planla neredeyse aynı olup mesajı görünmez kılabiliyordu.
class AppAlert {
  static void show(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.derinGri(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.safBeyaz(context),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(AppLocalizations.of(context)!.commonOk),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
