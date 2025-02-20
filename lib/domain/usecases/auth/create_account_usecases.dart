import 'package:reentry/core/usecase/usecase.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/keys.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class CreateAccountUseCase
    extends UseCase<AuthState, UserDto> {
  final _repo = AuthRepository();

  @override
  Future<AuthState> call(UserDto params) async {
    try {
      String? id = params.userId;
      if (id == null) {
        return AuthError('Unable to proceed');
      }

      final createAccountUser = params.copyWith(userId: id,createdAt: DateTime.now(),userCode: DateTime.now().millisecondsSinceEpoch.toString());
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
