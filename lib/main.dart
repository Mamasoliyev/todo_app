import 'package:todo_app/core/go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/firebase_options.dart';

import 'core/bloc/theme_bloc/app_theme_cubit.dart';
import 'core/bloc/theme_bloc/app_theme_state.dart';
import 'core/bloc/bloc_scope.dart';
import 'core/di/injection_container.dart' as di;

import 'core/locale/supported_locales.dart';
import 'core/style/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    EasyLocalization(
      supportedLocales: SupportedLocales.locales,
      path: "assets/translations",
      saveLocale: true,
      fallbackLocale: SupportedLocales.uzLocal,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScope(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => ScreenUtilInit(
          designSize: Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              locale: context.locale,
              themeMode: state.themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
            );
          },
        ),
      ),
    );
  }
}
