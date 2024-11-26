import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/domain/firebase_api.dart';
import '../../../../data/enum/emotions.dart';
import '../../../../data/model/user_dto.dart';

class AccountCubit extends Cubit<UserDto?> {
  AccountCubit() : super(null) {
    readFromLocalStorage();
  }

  final repository = AuthRepository();
  final _repo = AdminRepository();

  Future<void> fetchUsers() async {
    _repo.getUsers(AccountType.citizen);
  }

  Future<void> registerNotificationToken() async {
    final result = await PersistentStorage.getCurrentUser();
    if (result == null) {
      return;
    }
    final token = await FirebaseApi.getToken();
    if (token == null) {
      return;
    }
    final userInfo = result.copyWith(pushNotificationToken: token);
    repository.updateUser(userInfo);
  }

  Future<void> setAccount(UserDto account) async {
    emit(account);
  }

  Future<void> readFromLocalStorage() async {
    final result = await PersistentStorage.getCurrentUser();
    emit(result);
  }

  Future<void> logout() async {
    emit(null);
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
    final feelingToday = user.feelingToday;
    final alreadySet =
        feelingToday?.date.formatDate() == DateTime.now().formatDate();
    final currentEmotions =
        FeelingDto(date: DateTime.now(), emotion: currentEmotion);
    List<FeelingDto> resultFeelings = [
      if (!alreadySet) currentEmotions,
      ...user.feelingTimeLine
    ];
    if (alreadySet) {
      resultFeelings[0] = currentEmotions;
    }
    user = user.copyWith(
        emotion: currentEmotion,
        feelingToday: currentEmotions,
        feelingTimeLine: resultFeelings);

    await PersistentStorage.cacheUserInfo(user);
    await repository.updateUser(user);
    emit(user);
  }
}
