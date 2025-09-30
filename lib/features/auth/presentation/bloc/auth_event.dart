part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;
  EmailSignInRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class EmailSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  EmailSignUpRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {}

class FacebookSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class PhoneSignInRequested extends AuthEvent {
  final String phoneNumber;
  PhoneSignInRequested(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class PhoneCodeSent extends AuthEvent {
  final String verificationId;
  PhoneCodeSent(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class VerifyPhoneCodeRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  VerifyPhoneCodeRequested(this.verificationId, this.smsCode);
  @override
  List<Object?> get props => [verificationId, smsCode];
}

class PhoneVerificationFailed extends AuthEvent {
  final String error;
  PhoneVerificationFailed(this.error);
  @override
  List<Object?> get props => [error];
}

class SignOutRequested extends AuthEvent {}
