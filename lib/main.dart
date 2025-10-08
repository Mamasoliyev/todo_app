import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/core/go_router/go_router.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_state.dart';
import 'package:todo_app/core/locale/supported_locales.dart';
import 'package:todo_app/core/style/app_theme.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'core/di/injection_container.dart' as di;

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
      startLocale: SupportedLocales.engLocal,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<TodoBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'TODO',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            themeMode: state.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            builder: (context, child) {
              // ✅ ScreenUtil bu yerda ishlatiladi
              return ScreenUtilInit(
                designSize: const Size(390, 844),
                minTextAdapt: true,
                builder: (context, _) => child!,
              );
            },
          );
        },
      ),
    );
  }
}
