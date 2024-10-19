import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

sealed class AuthEvent {}
enum OAuthType{
  google,apple
}
class LoginEvent extends AuthEvent {
  final String password;
  final String email;

  LoginEvent({required this.password, required this.email});
}

class LogoutEvent extends AuthEvent {}
class OAuthEvent extends AuthEvent{
  OAuthType type;
   OAuthEvent(this.type);

}
class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithAppleEvent extends AuthEvent {}

class PasswordResetEvent extends AuthEvent {
  final String email;

  PasswordResetEvent(this.email);
}

class RegisterEvent extends AuthEvent {
  OnboardingEntity data;

  RegisterEvent({required this.data});
}
