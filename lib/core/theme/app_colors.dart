import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE85520);
  static const Color primaryLight = Color(0xFFFF8C5A);
  static const Color primarySurface = Color(0xFFFFF0EB);

  // Secondary
  static const Color secondary = Color(0xFF2EC4B6);
  static const Color secondaryDark = Color(0xFF1FA99C);
  static const Color secondaryLight = Color(0xFF5ED4CA);
  static const Color secondarySurface = Color(0xFFE8FAF9);

  // Accent
  static const Color accent = Color(0xFFFFBF00);
  static const Color accentDark = Color(0xFFE6AC00);

  // Neutrals — Light Mode
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F3F3);
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFDDDDDD);
  static const Color divider = Color(0xFFEEEEEE);

  // Neutrals — Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2A2A2A);
  static const Color borderDarkMode = Color(0xFF3A3A3A);
  static const Color dividerDark = Color(0xFF2A2A2A);

  // Text — Light Mode
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textHint = Color(0xFFBBBBBB);
  static const Color textDisabled = Color(0xFFCCCCCC);

  // Text — Dark Mode
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
  static const Color textTertiaryDark = Color(0xFF777777);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successSurface = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningSurface = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFF44336);
  static const Color errorSurface = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoSurface = Color(0xFFE3F2FD);

  // Rating
  static const Color star = Color(0xFFFFB800);

  // Category Colors
  static const Color burgerColor = Color(0xFFFF6B35);
  static const Color pizzaColor = Color(0xFFE71D36);
  static const Color bbqColor = Color(0xFF8B2500);
  static const Color fastFoodColor = Color(0xFFFFBF00);
  static const Color chineseColor = Color(0xFFE53935);
  static const Color dessertsColor = Color(0xFFEC407A);
  static const Color drinksColor = Color(0xFF42A5F5);
  static const Color healthyColor = Color(0xFF66BB6A);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];
}
