import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Bundled Poppins — no runtime network font fetch.
abstract final class AppTypography {
  static const String fontFamily = 'Poppins';

  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.green,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextTheme textTheme = TextTheme(
    titleLarge: poppins(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: poppins(fontSize: 18, fontWeight: FontWeight.w600),
    bodyMedium: poppins(fontSize: 14),
    bodySmall: poppins(fontSize: 12),
    labelLarge: poppins(fontSize: 14, fontWeight: FontWeight.w600),
  );
}
