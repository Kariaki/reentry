import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

sealed class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String password;
  final String email;

  LoginEvent({required this.password, required this.email});
}

class LogoutEvent extends AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithAppleEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  OnboardingEntity data;
   RegisterEvent({required this.data});
}
