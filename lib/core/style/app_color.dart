// app_color.dart
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

class AppColors {
  // Light
  static const Color primary = Color(0xFF1B85F3); // Modern blue
  static const Color textPrimary = Color(0xFF1D1B20); // Dark neutral
  static const Color textSecondary = Color(0xFF49454F); // Medium neutral
  static const Color textLight = Color(0xFFFFFFFF); // White
  static Color cardBackground = Colors.grey.shade100;
  static const Color border = Color(0xFFE6E0E9); // Light border
  static const Color productGray = Color(0xFF7D7A85); // Neutral gray
  static const Color productBlue = Color(0xFF1B85F3); // Modern blue
  static const Color productDark = Color(0xFF1C1B1F); // Near black
  static const Color error = Color(0xFFB3261E); // Material 3 error red
  static const Color background = Color(0xFFFFFFFF); // White

  // Dark
  static const Color darkBackground = Colors.black; // Pure dark
  static const Color darkCard = Color.fromARGB(255, 60, 53, 53); // Dark card
  static const Color darkTextPrimary = Color(0xFFE6E0E9); // Light text
  static const Color darkTextSecondary = Color(0xFFCAC4D0); // Subtle neutral
  static const Color darkBorder = Color(0xFF1B85F3); // Accent border
}
