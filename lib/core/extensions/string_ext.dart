import 'package:flutter/material.dart';

extension StringExt on String {
  ThemeMode get toThemeMode {
    switch (this) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      case "system":
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}
