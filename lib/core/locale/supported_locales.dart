import 'package:flutter/material.dart';

class SupportedLocales {
  static List<Locale> locales = const [
    Locale("en", "US"),
    Locale("ru", "RU"),
    Locale("uz", "UZ"),
  ];

  static Locale engLocal = const Locale("en", "US");

  static Locale ruLocal = const Locale("ru", "RU");

  static Locale uzLocal = const Locale('uz', 'UZ');
}

class SupportedLanguages {
  static const String english = "en-US";
  static const String russian = "ru-RU";
  static const String uzbek = "uz-UZ";
}