import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.green,
        onPrimary: AppColors.white,
        secondary: AppColors.yellow,
        onSecondary: AppColors.green,
        surface: AppColors.white,
        onSurface: AppColors.green,
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: 56,
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: AppTypography.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          borderSide: const BorderSide(color: AppColors.green, width: 2),
        ),
        labelStyle: AppTypography.poppins(fontSize: 14),
        hintStyle: AppTypography.poppins(fontSize: 14),
      ),
      textTheme: AppTypography.textTheme,
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: const BorderSide(color: AppColors.green, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.green, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.green,
        contentTextStyle: AppTypography.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: const BorderSide(color: AppColors.yellow, width: 2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.green,
        textColor: AppColors.green,
        titleTextStyle: AppTypography.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        subtitleTextStyle: AppTypography.poppins(fontSize: 12),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.green,
          textStyle: AppTypography.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          minimumSize: Size(0, AppSpacing.fieldHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
          textStyle: AppTypography.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
