import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class VerifySmsCode {
  final AuthRepository repository;
  VerifySmsCode(this.repository);

  Future<UserEntity> call(String verificationId, String smsCode) {
    return repository.verifySmsCode(verificationId, smsCode);
  }
}
