import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/features/auth/data/models/user_model.dart';
import 'package:todo_app/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/user_entity.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final user = await datasource.signInWithEmail(email, password);
    if (user == null) throw Exception('Sign in failed');
    return _mapToEntity(user);
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password) async {
    final user = await datasource.signUpWithEmail(email, password);
    if (user == null) throw Exception('Sign up failed');
    return _mapToEntity(user);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final user = await datasource.signInWithGoogle();
    if (user == null) throw Exception('Google sign in cancelled');
    return _mapToEntity(user);
  }

  @override
  Future<UserEntity> signInWithFacebook() async {
    final user = await datasource.signInWithFacebook();
    if (user == null) throw Exception('Facebook sign in cancelled');
    return _mapToEntity(user);
  }

  @override
  Future<UserEntity> signInWithApple() async {
    final user = await datasource.signInWithApple();
    if (user == null) throw Exception('Apple sign in cancelled');
    return _mapToEntity(user);
  }

  @override
  Future<void> signOut() async => await datasource.signOut();

  @override
  Stream<UserEntity?> get userChanges => datasource.authStateChanges.map(
    (user) => user == null ? null : _mapToEntity(user),
  );

  UserEntity _mapToEntity(User user, {UserModel? model}) {
    return UserEntity(
      user.uid,
      model?.name ?? user.displayName ?? '',
      user.email ?? '',
      user.phoneNumber ?? '',
      user.photoURL ?? '',
      model?.addresses.map((e) => e.toJson()).toList() ?? [],
      model?.wishlist ?? [],
      model?.createdAt ?? DateTime.now().toUtc(),
      model?.isBlocked ?? false,
    );
  }

}
