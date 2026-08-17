import 'package:flutter/material.dart';

class AppColors {
  // Primary Romantic Palette
  static const Color primary = Color(0xFFFF4B72);       // Rose Passion
  static const Color primaryLight = Color(0xFFFF7A97);  // Soft Pink
  static const Color primaryDark = Color(0xFFD62249);   // Deep Rose
  static const Color secondary = Color(0xFFFF8A65);     // Coral Flame
  static const Color accent = Color(0xFFFFD166);        // Golden Spark

  // Streaks Flame Colors
  static const Color flameOrange = Color(0xFFFF5722);
  static const Color flameYellow = Color(0xFFFFC107);
  static const Color streakFire = Color(0xFFFF3D00);

  // Period Tracker Colors
  static const Color periodFlow = Color(0xFFE91E63);     // Ngày hành kinh
  static const Color ovulation = Color(0xFF9C27B0);      // Ngày rụng trứng
  static const Color fertileWindow = Color(0xFFBA68C8);  // Cửa sổ thụ thai
  static const Color safeDay = Color(0xFF4CAF50);        // Ngày an toàn

  // Neutral & Dark Mode Canvas
  static const Color backgroundLight = Color(0xFFFFF9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121217);
  static const Color surfaceDark = Color(0xFF1E1E26);
  static const Color cardDark = Color(0xFF282834);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C24);
  static const Color textSecondary = Color(0xFF75758A);
  static const Color textLight = Color(0xFFF5F5FA);
  static const Color textMuted = Color(0xFF9E9EA8);

  // Gradients
  static const LinearGradient loveGradient = LinearGradient(
    colors: [Color(0xFFFF4B72), Color(0xFFFF7A97)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient flameGradient = LinearGradient(
    colors: [Color(0xFFFF3D00), Color(0xFFFF9100)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF262636), Color(0xFF1A1A24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient periodGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFBA68C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
