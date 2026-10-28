import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1B5E20);   // Hijau tua profesional
  static const secondary = Color(0xFF0D47A1); // Aksen biru
  static const success = Color(0xFF2E7D32);   // Status presensi valid
  static const warning = Color(0xFFF57C00);   // Status di luar radius / retry
  static const danger = Color(0xFFC62828);    // Verifikasi gagal
}

class AppSpace {
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
}

class AppTheme {
  static ThemeData get light => ThemeData(
    colorSchemeSeed: AppColors.primary,
    useMaterial3: true,
  );
}
