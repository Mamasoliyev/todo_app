import 'package:flutter/material.dart';

extension ThemeExt on ThemeMode {
  String get stringValue {
    switch (this) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.system:
        return "system";
      default:
        return "dark";
    }
  }
}
