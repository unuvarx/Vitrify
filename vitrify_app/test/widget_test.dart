import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitrify_app/config/app_colors.dart';

void main() {
  test('AppColors koyu ve açık tema renklerini doğru tanımlar', () {
    expect(AppColors.darkBackground, const Color(0xFF0A0A12));
    expect(AppColors.darkTextPrimary, const Color(0xFFF1F0F7));
    expect(AppColors.darkPrimary, const Color(0xFF7C6CFF));
    expect(AppColors.darkSurface, const Color(0xFF1C1B29));

    expect(AppColors.lightBackground, const Color(0xFFF5F4FF));
    expect(AppColors.lightTextPrimary, const Color(0xFF17151F));
    expect(AppColors.lightPrimary, const Color(0xFF6C5CE0));
    expect(AppColors.lightSurface, const Color(0xFFFFFFFF));

    // Arka plan ve kart renkleri belirgin şekilde farklı olmalı
    expect(AppColors.darkBackground, isNot(AppColors.darkSurface));
    expect(AppColors.lightBackground, isNot(AppColors.lightSurface));
  });
}
