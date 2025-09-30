import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(state.copyWith(themeMode: newMode));
  }
}
