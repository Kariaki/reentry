import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_login);
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    //repository login
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 3));
    emit(AuthSuccess());
  }

  Future<void> _register(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 3));
    emit(RegistrationSuccessFull());
  }
}
