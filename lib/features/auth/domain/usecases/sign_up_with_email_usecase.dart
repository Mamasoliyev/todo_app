import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class SignUpWithEmail {
  final AuthRepository repository;
  SignUpWithEmail(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.signUpWithEmail(email, password);
  }
}
