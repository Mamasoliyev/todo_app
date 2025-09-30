part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class PhoneVerificationSentState extends AuthState {
  final String verificationId;
  PhoneVerificationSentState(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class PhoneVerificationFailedState extends AuthState {
  final String message;
  PhoneVerificationFailedState(this.message);
  @override
  List<Object?> get props => [message];
}
