import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vitrify_app/config/app_colors.dart';

void main() {
  test('AppColors Vitrify paletini doğru tanımlar', () {
    expect(AppColors.geceSiyahi, const Color(0xFF0A0A0A));
    expect(AppColors.safBeyaz, const Color(0xFFFFFFFF));
    expect(AppColors.vitrifyMavisi, const Color(0xFF3D5AFE));
    expect(AppColors.derinGri, const Color(0xFF1E1E1E));
  });
}
