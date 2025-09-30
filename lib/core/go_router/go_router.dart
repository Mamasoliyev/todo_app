import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/features/auth/presentation/pages/onboarding_page.dart';
import 'package:todo_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:todo_app/features/todo/presentation/pages/todo_page.dart';

import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';

final GoRouter router = GoRouter(
  initialLocation: "/splash",
  routes: [
    // Splash
    GoRoute(path: "/splash", builder: (context, state) => const SplashPage()),

    // Onboarding
    GoRoute(
      path: "/onboarding",
      builder: (context, state) => const OnboardingPage(),
    ),

    // Sign In (Phone Number Input)
    GoRoute(path: "/sign-in", builder: (context, state) => const SignInPage()),
    GoRoute(path: "/sign-up", builder: (context, state) => const SignUpPage()),
    GoRoute(path: "/todo", builder: (context, state) => const TodoPage()),
  ],

  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text("❌ Page not found: ${state.uri}"))),
);
