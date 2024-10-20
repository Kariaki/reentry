import 'package:reentry/core/usecase/usecase.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/keys.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class CreateAccountWithEmailAndPasswordUseCase
    extends UseCase<AuthState, UserDto> {
  final _repo = AuthRepository();

  @override
  Future<AuthState> call(UserDto params) async {
    try {
      String? id = params.userId;
      if (id == null) {
        final email = params.email;
        final password = params.password;
        if (email == null || password == null) {
          return AuthError("Email and password required");
        }
        final user = await _repo.createAccountWithEmailAndPassword(
            email: params.email!, password: params.password!);
        id = user?.uid;
      }
      if (id == null) {
        return AuthError('Unable to proceed');
      }

      final createAccountUser = params.copyWith(userId: id);
      final result = await _repo.createAccount(createAccountUser);
      //cache data
      final pref = await locator.getAsync<PersistentStorage>();
      await pref.cacheData(data: result.toJson(), key: Keys.user);
      return RegistrationSuccessFull(result);
    } catch (e) {
      return AuthError(e.toString());
    }
  }
}
