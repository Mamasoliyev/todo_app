import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:todo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_app/features/todo/data/datasources/remote/todo_remote_data_source.dart';
import 'package:todo_app/features/todo/data/datasources/remote/todo_remote_data_source_impl.dart';
import 'package:todo_app/features/todo/data/repo/todo_repo_impl.dart';
import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

// Auth




final sl = GetIt.instance;

Future<void> init() async {
  // Theme
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ========== AUTH ==========
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasource(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<FirebaseAuthDatasource>()),
  );

  // Auth Usecases
  sl.registerLazySingleton(() => SignInWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithFacebook(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithApple(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));

  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signInWithGoogle: sl(),
      signInWithFacebook: sl(),
      signInWithApple: sl(),
      signOut: sl(),
    ),
  );


// Todo datasource
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Todo repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl<TodoRemoteDataSource>()),
  );

  // Todo usecases
  sl.registerLazySingleton(() => AddTodoUseCase(sl<TodoRepository>()));
  sl.registerLazySingleton(() => GetTodosUseCase(sl<TodoRepository>()));
  sl.registerLazySingleton(() => UpdateTodoUseCase(sl<TodoRepository>()));
  sl.registerLazySingleton(() => DeleteTodoUseCase(sl<TodoRepository>()));

  // Todo Bloc
  sl.registerFactory(
    () => TodoBloc(
      addTodo: sl(),
      getTodos: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
    ),
  );
}
