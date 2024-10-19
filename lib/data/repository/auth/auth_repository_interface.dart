import '../../model/create_account_dto.dart';
import '../../model/user_dto.dart';

abstract class AuthRepositoryInterface {
  Future<UserDto> login({required String email, required String password});

  Future<UserDto> googleSignIn();

  Future<UserDto> appleSignIn();

  Future<UserDto> createAccount(UserDto createAccount);

  Future<void> createAccountWithEmailAndPassword(
      {required String email, required String password});

  Future<void> resetPassword({required String email});
}
