import 'package:reentry/data/shared/keys.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/repository/auth/auth_repository.dart';
import '../../../ui/modules/authentication/bloc/authentication_state.dart';

class LoginUseCase
    extends UseCase<AuthState, LoginEvent> {
  final _repo = AuthRepository();

  @override
  Future<AuthState> call(LoginEvent params) async {
    try {
      final login =
          await _repo.login(email: params.email, password: params.password);
      final pref = await locator.getAsync<PersistentStorage>();
      await pref.cacheData(data: login.toJson(), key: Keys.user);
      return LoginSuccess(login);
    } catch (e) {
      return AuthError(e.toString());
    }
  }
}
