import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignInWithFacebook {
  final AuthRepository repository;
  SignInWithFacebook(this.repository);

  Future<UserEntity> call() {
    return repository.signInWithFacebook();
  }
}
