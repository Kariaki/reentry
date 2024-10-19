import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/shared/share_preference.dart';
import '../../../../data/model/user_dto.dart';

class AccountCubit extends Cubit<UserDto?> {
  AccountCubit():super(null) {
    readFromLocalStorage();
  }

  Future<void> readFromLocalStorage() async {
    final result = await PersistentStorage.getCurrentUser();
    emit(result);
  }
}
