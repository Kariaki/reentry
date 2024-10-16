import 'package:reentry/data/model/create_account_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository_interface.dart';

class AuthRepository extends AuthRepositoryInterface{
  @override
  Future<UserDto> appleSignIn() {
    // TODO: implement appleSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> createAccount(CreateAccountDto createAccount) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<UserDto> googleSignIn() async{
    // TODO: implement googleSignIn
    throw UnimplementedError();
  }

  @override
  Future<UserDto> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({required String email}) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

}