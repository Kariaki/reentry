import '../../model/create_account_dto.dart';
import '../../model/user_dto.dart';

abstract class AuthRepositoryInterface {
  Future<UserDto> login({required String email, required String password});

  Future<UserDto> googleSignIn();

  Future<UserDto> appleSignIn();

  Future<void> createAccount(CreateAccountDto createAccount);


  Future<void> resetPassword({required String email});
}
