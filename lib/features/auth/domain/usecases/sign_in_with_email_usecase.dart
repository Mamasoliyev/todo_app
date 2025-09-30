import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInWithEmail {
  final AuthRepository repository;
  SignInWithEmail(this.repository);
  Future<UserEntity> call(String email, String password) =>
      repository.signInWithEmail(email, password);
}
