import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      emit(
        ThemeState(
          themeMode: savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
        ),
      );
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(ThemeState(themeMode: newMode));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
