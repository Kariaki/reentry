import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';

import '../../../../data/model/user_dto.dart';
import '../../../../data/repository/auth/auth_repository.dart';

class UserProfileCubit extends Cubit<ProfileState> {
  UserProfileCubit() : super(ProfileState()) {}

  final repository = AuthRepository();

  Future<void> loadFromCloud(String userId) async {
    emit(ProfileLoading());
    try {
      final userCloudAccount = await repository.findUserById(userId);
      if(userCloudAccount==null){
        emit(ProfileError('Account not found'));
        return;
      }
      emit(ProfileDataSuccess(userCloudAccount));
    }catch(e){
      emit(ProfileError(e.toString()));
    }
  }
}
