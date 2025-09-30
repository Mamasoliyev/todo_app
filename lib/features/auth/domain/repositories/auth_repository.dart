import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithFacebook();
  Future<UserEntity> signInWithApple();
  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(Exception) verificationFailed,
  });
  Future<UserEntity> verifySmsCode(String verificationId, String smsCode);
  Future<void> signOut();
  Stream<UserEntity?> get userChanges;
}
