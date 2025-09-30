
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/core/di/injection_container.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

class BlocScope extends StatelessWidget {
  final Widget child;

  BlocScope({super.key, required this.child});
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ThemeCubit>()),
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<TodoBloc>()),
       
        
      ],
      child: child,
    );
  }
}
