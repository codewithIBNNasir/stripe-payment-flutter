// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  COLOUR PALETTE
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand
  static const Color primary         = Color(0xFF1A1A2E);
  static const Color primaryLight    = Color(0xFF2A2A42);
  static const Color accent          = Color(0xFF7B68EE);

  // Backgrounds
  static const Color bgPage          = Color(0xFFF8F7F4);
  static const Color bgCard          = Color(0xFFFFFFFF);
  static const Color bgInput         = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary     = Color(0xFF1A1A2E);
  static const Color textSecondary   = Color(0xFF6B6B80);
  static const Color textHint        = Color(0xFFCCCCCC);
  static const Color textMuted       = Color(0xFF9E9E9E);

  // Borders
  static const Color border          = Color(0xFFEEEEEE);
  static const Color borderLight     = Color(0xFFE0E0E0);

  // Semantic — success
  static const Color success         = Color(0xFF22C55E);
  static const Color successBg       = Color(0xFFECFDF5);
  static const Color successBorder   = Color(0xFF86EFAC);
  static const Color successText     = Color(0xFF15803D);

  // Semantic — error
  static const Color error           = Color(0xFFEF4444);
  static const Color errorBg         = Color(0xFFFFF1F2);
  static const Color errorBorder     = Color(0xFFFCA5A5);
  static const Color errorText       = Color(0xFFB91C1C);

  // Dark card palette
  static const Color cardDark        = Color(0xFF1A1A2E);
  static const Color cardDarkSurface = Color(0xFF2A2A42);
  static const Color cardLabel       = Color(0xFF9E9CA8);

  // Status tickers
  static const Color positive        = Color(0xFF4ADE80);
  static const Color negative        = Color(0xFFFF6B6B);
}

// ─────────────────────────────────────────────
//  TEXT STYLES
// ─────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36, fontWeight: FontWeight.w700,
    color: Colors.white, letterSpacing: -1.5,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.8,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary, letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500,
    color: AppColors.textMuted, letterSpacing: 0.3,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: Colors.white, letterSpacing: -0.3,
  );

  static const TextStyle amountInput = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );
}

// ─────────────────────────────────────────────
//  DIMENSIONS
// ─────────────────────────────────────────────
class AppDimens {
  AppDimens._();

  static const double radiusSm   = 8.0;
  static const double radiusMd   = 12.0;
  static const double radiusLg   = 16.0;
  static const double radiusXl   = 22.0;
  static const double radiusFull = 999.0;

  static const double spaceXs  = 4.0;
  static const double spaceSm  = 8.0;
  static const double spaceMd  = 16.0;
  static const double spaceLg  = 24.0;
  static const double spaceXl  = 32.0;
  static const double spaceXxl = 40.0;

  static const double buttonHeight = 60.0;
  static const double inputHeight  = 62.0;
  static const double pagePadding  = 24.0;
}

// ─────────────────────────────────────────────
//  THEME DATA
// ─────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bgPage,
      colorScheme: const ColorScheme.light(
        primary:   AppColors.primary,
        secondary: AppColors.accent,
        surface:   AppColors.bgCard,
        error:     AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor:        AppColors.bgPage,
        elevation:              0,
        scrolledUnderElevation: 0,
        centerTitle:            true,
        systemOverlayStyle:     SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: -0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: AppColors.bgInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          borderSide:   const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle:      AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge:   AppTextStyles.displayLarge,
        headlineLarge:  AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall:  AppTextStyles.h3,
        bodyLarge:      AppTextStyles.bodyLarge,
        bodyMedium:     AppTextStyles.bodyMedium,
        bodySmall:      AppTextStyles.bodySmall,
        labelLarge:     AppTextStyles.labelLarge,
        labelSmall:     AppTextStyles.labelSmall,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
      ),
    );
  }
}