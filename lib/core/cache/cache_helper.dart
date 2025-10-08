import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/extensions/string_ext.dart';
import 'package:todo_app/core/extensions/theme_ext.dart';

class CacheHelper {
  const CacheHelper(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = "theme-mode";
  static const _onboardingSeenKey = "seen-onboarding";
  static const _isFilledpersonalInfoKey = "isFilled-personal-info";
  static const _sessionToken = "sessionToken";

  Future<void> resetSession() async {
    await _prefs.remove(_sessionToken);
  }

  // === Session Token ===
  Future<void> cacheSessionToken(String token) async {
    await _prefs.setString(_sessionToken, token);
    log("Session token cached");
  }

  String? getSessionToken() {
    return _prefs.getString(_sessionToken);
  }

  // === Theme Mode ===
  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.stringValue);
    log('Cached theme mode: $themeMode');
  }

  ThemeMode getThemeMode() {
    final themeModeString = _prefs.getString(_themeModeKey);
    log('Retrieved theme mode from cache: $themeModeString');
    log("theme from cache: ${themeModeString?.toThemeMode}");
    final themeMode = themeModeString?.toThemeMode ?? ThemeMode.dark;
    return themeMode;
  }

 Future<void> clearThemeMode() async {
    await _prefs.remove(_themeModeKey);
    log('🗑️ Cleared cached theme mode');
  }

  // === Onboarding ===
  Future<void> cacheLanguageSelected() async {
    await _prefs.setBool(_onboardingSeenKey, true);
    log('Cached languageSelected seen flag: true');
  }

  bool get isLanguageSelected {
    final seen = _prefs.getBool(_onboardingSeenKey) ?? false;
    log('Retrieved languageSelected seen flag: $seen');
    return seen;
  }

  // === Personal info ===
  Future<void> cacheFilledPersonalInfo(bool value) async {
    await _prefs.setBool(_isFilledpersonalInfoKey, value);
  }

  bool get isFilledPersonalInfo {
    final filled = _prefs.getBool(_isFilledpersonalInfoKey) ?? false;
    return filled;
  }
}
