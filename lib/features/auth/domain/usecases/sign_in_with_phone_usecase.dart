import '../repositories/auth_repository.dart';

class SignInWithPhone {
  final AuthRepository repository;
  SignInWithPhone(this.repository);

  Future<void> call({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(Exception) verificationFailed,
  }) {
    return repository.signInWithPhone(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationFailed: verificationFailed,
    );
  }
}
