import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/shared/share_preference.dart';
import '../../../../data/enum/emotions.dart';
import '../../../../data/model/user_dto.dart';

class AccountCubit extends Cubit<UserDto?> {
  AccountCubit() : super(null) {
    readFromLocalStorage();
  }

  Future<void> readFromLocalStorage() async {
    final result = await PersistentStorage.getCurrentUser();
    emit(result);
  }

  Future<void> updateFeeling(Emotions currentEmotion) async {
    UserDto? user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    user = user.copyWith(emotion: currentEmotion);

    ///take it from here to firebase
    ///cache user info
    await PersistentStorage.cacheUserInfo(user);
    emit(user);
  }
}
