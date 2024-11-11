import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import '../../../../data/enum/emotions.dart';
import '../../../../data/model/user_dto.dart';

class AccountCubit extends Cubit<UserDto?> {
  AccountCubit() : super(null) {
    readFromLocalStorage();
  }

  final repository = AuthRepository();
  final _repo = AdminRepository();
  Future<void> fetchUsers()async{
    _repo.getUsers(AccountType.citizen);
  }

  Future<void> readFromLocalStorage() async {
    final result = await PersistentStorage.getCurrentUser();
    emit(result);
  }

  Future<void> loadFromCloud() async {
    final result = await PersistentStorage.getCurrentUser();
    if (result == null) {
      return;
    }
    final userCloudAccount = await repository.findUserById(result.userId!);
    emit(userCloudAccount);
  }

  Future<void> updateFeeling(Emotions currentEmotion) async {
    UserDto? user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    user = user.copyWith(emotion: currentEmotion);

    ///TODO Hanniel Daniel
    ///take it from here to firebase
    ///cache user info
    await PersistentStorage.cacheUserInfo(user);
    await repository.updateUser(user);
    emit(user);
  }
}
