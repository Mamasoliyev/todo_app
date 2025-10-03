import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_facebook_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:todo_app/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInWithFacebook signInWithFacebook;
  final SignInWithApple signInWithApple;
  final SignOut signOut;

  AuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.signInWithApple,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<EmailSignInRequested>(_onEmailSignIn);
    on<EmailSignUpRequested>(_onEmailSignUp);
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<FacebookSignInRequested>(_onFacebookSignIn);
    on<AppleSignInRequested>(_onAppleSignIn);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onEmailSignIn(
    EmailSignInRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInWithEmail(e.email, e.password);
      emit(Authenticated(user));
    } catch (ex) {
      emit(AuthFailure(ex.toString()));
    }
  }

  Future<void> _onEmailSignUp(
    EmailSignUpRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signUpWithEmail(e.email, e.password);
      emit(Authenticated(user));
    } catch (ex) {
      emit(AuthFailure(ex.toString()));
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInWithGoogle();
      emit(Authenticated(user));
    } catch (ex) {
      emit(AuthFailure(ex.toString()));
    }
  }

  Future<void> _onFacebookSignIn(
    FacebookSignInRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInWithFacebook();
      emit(Authenticated(user));
    } catch (ex) {
      emit(AuthFailure(ex.toString()));
    }
  }

  Future<void> _onAppleSignIn(
    AppleSignInRequested e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signInWithApple();
      emit(Authenticated(user));
    } catch (ex) {
      emit(AuthFailure(ex.toString()));
    }
  }

  

  Future<void> _onSignOut(SignOutRequested e, Emitter<AuthState> emit) async {
    await signOut();
    emit(AuthInitial());
  }
}
