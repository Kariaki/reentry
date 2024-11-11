import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/domain/usecases/auth/create_account_usecases.dart';
import 'package:reentry/domain/usecases/auth/login_usecase.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../data/shared/keys.dart';
import '../../../../di/get_it.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<OAuthEvent>(_OAuthSignIn);
    on<LogoutEvent>(_logout);
    on<PasswordResetEvent>(_passwordReset);
    on<CreateAccountEvent>(_createAccountWithEmailAndPasswordEvent);
  }

  final _repository = AuthRepository();

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await PersistentStorage.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _passwordReset(
      PasswordResetEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.resetPassword(email: event.email);
      emit(PasswordResetSuccess(resend: event.resend));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    //repository login
    emit(LoginLoading());
    final result = await LoginUseCase().call(event);
    emit(result);
  }

  Future<void> _createAccountWithEmailAndPasswordEvent(
      CreateAccountEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final result = await _repository.createAccountWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(AuthenticationSuccess(result?.uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await CreateAccountUseCase().call(event.data.toUserDto());
    emit(result);
  }

  Future<void> _OAuthSignIn(OAuthEvent event, Emitter<AuthState> emit) async {
    OAuthCredential? credential;
    if (event.type == OAuthType.google) {
      credential = await _signInWithGoogle(emit);
    } else {
      credential = await _signInWithApple(emit);
    }
    if (credential == null) {
      return;
    }
    emit(AuthLoading());

    try {
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final value = await _repository.findUserById(result.user?.uid ?? '');
      if (value != null) {
        final pref = await locator.getAsync<PersistentStorage>();
        await pref.cacheData(data: value.toJson(), key: Keys.user);
      }
      emit(OAuthSuccess(value,
          email: result.user?.email ?? '',
          name: result.user?.displayName,
          id: result.user?.uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

Future<OAuthCredential?> _signInWithGoogle(Emitter<AuthState> emit) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return credential;
  } catch (e) {
    emit(AuthError(e.toString()));
    return null;
  }
}

Future<OAuthCredential?> _signInWithApple(Emitter<AuthState> emit) async {
  try {
    // Trigger the authentication flow
    final googleUser = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ]);
    final token = googleUser.identityToken;
    if (token == null) {
      emit(AuthError('Something went wrong'));
    }

    final provider = OAuthProvider('apple.com');
    final credential = provider.credential(
        accessToken: googleUser.authorizationCode, idToken: token);
    return credential;
  } catch (e) {
    emit(AuthError(e.toString()));
    return null;
  }
}
