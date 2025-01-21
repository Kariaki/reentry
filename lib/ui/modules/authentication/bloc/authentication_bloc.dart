import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/domain/usecases/auth/create_account_usecases.dart';
import 'package:reentry/domain/usecases/auth/login_usecase.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../data/shared/keys.dart';
import '../../../../di/get_it.dart';

class OAuthCredentialWrapper {
  final OAuthCredential credential;
  final String? name;
  const OAuthCredentialWrapper({required this.credential, required this.name});
}

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
      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }
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
    OAuthCredentialWrapper? credential;
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
      final result = await FirebaseAuth.instance
          .signInWithCredential(credential.credential);
      final value = await _repository.findUserById(result.user?.uid ?? '');
      if (value != null) {
        final pref = await locator.getAsync<PersistentStorage>();
        await pref.cacheData(data: value.toJson(), key: Keys.user);
      }
      emit(OAuthSuccess(value,
          email: result.user?.email ?? '',
          name: credential.name,
          id: result.user?.uid));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

Future<OAuthCredentialWrapper?> _signInWithGoogle(
    Emitter<AuthState> emit) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    print('google auth user -> ${googleUser?.displayName}');
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    return OAuthCredentialWrapper(
        credential: credential, name: googleUser?.displayName);
  } catch (e) {
    emit(AuthError(e.toString()));
    return null;
  }
}

Future<OAuthCredentialWrapper?> _signInWithApple(
    Emitter<AuthState> emit) async {
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

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token ?? '');

    return OAuthCredentialWrapper(
        credential: credential, name: googleUser.givenName);
  } catch (e) {
    emit(AuthError(e.toString()));
    return null;
  }
}
