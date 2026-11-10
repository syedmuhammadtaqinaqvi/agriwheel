import 'package:flutter/material.dart';

/// Strict AgriWheel palette (3 colors + semantic aliases for legacy modules).
abstract final class AppColors {
  static const Color green = Color(0xFF1B5E20);
  static const Color yellow = Color(0xFFFFC107);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic (map to strict palette only)
  static const Color brand = green;
  static const Color primary = green;
  static const Color primaryContainer = green;
  static const Color accent = yellow;
  static const Color secondaryContainer = yellow;
  static const Color surface = white;
  static const Color surfaceLow = white;
  static const Color surfaceContainer = white;
  static const Color onPrimary = white;
  static const Color onSurface = green;
  static const Color secondary = green;
}
