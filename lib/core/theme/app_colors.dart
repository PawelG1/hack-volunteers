import 'package:flutter/material.dart';

/// Kolory aplikacji bazujące na logo "Młody Kraków"
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Główne kolory z logo
  static const Color primaryMagenta = Color(0xFFD5437F); // Różowy/Magenta z logo
  static const Color primaryBlue = Color(0xFF2B8DC1); // Niebieski z logo
  static const Color primaryGreen = Color(0xFF7AB51D); // Zielony (liście)
  static const Color accentOrange = Color(0xFFF39200); // Pomarańczowy
  static const Color accentPurple = Color(0xFF9C4C9F); // Fioletowy

  // Tła i powierzchnie
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFFAFAFA);

  // Teksty
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // Akcje (eventy - kategorie)
  static const Color animalsCare = Color(0xFFFF6B35); // Pomarańczowy dla zwierząt
  static const Color environment = Color(0xFF7AB51D); // Zielony dla środowiska
  static const Color education = Color(0xFF2B8DC1); // Niebieski dla edukacji
  static const Color culture = Color(0xFFD5437F); // Różowy dla kultury
  static const Color health = Color(0xFF9C4C9F); // Fioletowy dla zdrowia
  static const Color sports = Color(0xFFF39200); // Pomarańczowy dla sportu
  static const Color social = Color(0xFFE91E63); // Różowy dla pomocy społecznej
  static const Color other = Color(0xFF607D8B); // Szary dla innych

  // Statusy
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient dla header/cards
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryMagenta,
      accentPurple,
      primaryBlue,
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryBlue,
      primaryGreen,
    ],
  );

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  /// Get category color by category name
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'animals':
      case 'zwierzęta':
        return animalsCare;
      case 'environment':
      case 'środowisko':
        return environment;
      case 'education':
      case 'edukacja':
        return education;
      case 'culture':
      case 'kultura':
        return culture;
      case 'health':
      case 'zdrowie':
        return health;
      case 'sports':
      case 'sport':
        return sports;
      case 'social':
      case 'pomoc społeczna':
        return social;
      default:
        return other;
    }
  }

  /// Get category gradient by category name
  static LinearGradient getCategoryGradient(String category) {
    final color = getCategoryColor(category);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withOpacity(0.7),
      ],
    );
  }
}
