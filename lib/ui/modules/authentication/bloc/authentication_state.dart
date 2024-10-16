sealed class AuthState{}

class AuthInitial extends AuthState{}
class AuthLoading extends AuthState{}
class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
}
class AuthSuccess extends AuthState{}
//login success
//registration success
//