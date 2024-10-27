import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/domain/usecases/auth/create_account_usecases.dart';
import 'package:reentry/domain/usecases/auth/login_usecase.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<OAuthEvent>(_OAuthSignIn);
    on<LogoutEvent>(_logout);
    on<CreateAccountEvent>(_createAccountWithEmailAndPasswordEvent);
  }

  final _repository = AuthRepository();

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await PersistentStorage.logout();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    //repository login
    emit(AuthLoading());
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
    } else {}
    if (credential == null) {
      return;
    }
    emit(AuthLoading());

    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    _repository.findUserById(result.user?.uid ?? '').then((value) {
      if (value != null) {
        //cache result and login
      }
      emit(OAuthSuccess(value,
          email: result.user?.email ?? '',
          name: result.user?.displayName,
          id: result.user?.uid));
    }).catchError((_) {
      emit(AuthError(_.toString()));
    });
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
