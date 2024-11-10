import '../../../domain/usecases/auth/login_usecase.dart';
import '../../model/user_dto.dart';

abstract class AuthRepositoryInterface {
  Future<LoginResponse?> login({required String email, required String password});

  Future<UserDto> googleSignIn();

  Future<UserDto> appleSignIn();

  Future<UserDto> createAccount(UserDto createAccount);

  Future<void> updateUser(UserDto payload);

  Future<void> createAccountWithEmailAndPassword(
      {required String email, required String password});

  Future<void> resetPassword({required String email});
}
