import 'package:flutter/foundation.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/shared/keys.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/model/user_dto.dart';
import '../../../data/repository/auth/auth_repository.dart';
import '../../../ui/modules/authentication/bloc/authentication_state.dart';

class LoginResponse {
  final UserDto? data;
  final String? authId;

  const LoginResponse(this.authId, this.data);
}

class LoginUseCase extends UseCase<AuthState, LoginEvent> {
  final _repo = AuthRepository();

  @override
  Future<AuthState> call(LoginEvent params) async {
    try {
      final login =
          await _repo.login(email: params.email, password: params.password);
      if (login == null) {
        return AuthError('Something went wrong!');
      }

      if((login.data?.accountType==AccountType.reentry_orgs || login.data?.accountType==AccountType.admin) && kIsWeb==false){
        return AuthError('Please login with our website');
      }
      if (login.data != null) {
        final pref = await locator.getAsync<PersistentStorage>();
        await pref.cacheData(data: login.data!.toJson(), key: Keys.user);
        if (params.rememberMe) {
          await pref.cacheString(data: params.email, key: Keys.remember);
        }
      }
      return LoginSuccess(login.data, authId: login.authId);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      return AuthError(e.toString());
    }
  }
}
