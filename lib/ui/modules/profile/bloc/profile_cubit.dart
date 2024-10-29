import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/resources/data_state.dart';
import 'package:reentry/core/util/image_util.dart';
import 'package:reentry/domain/usecases/user/update_profile_photo_usecase.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> updateProfilePhoto(XFile file) async {
    final cropImage = await ImageUtil.cropImage(file, true);
    if(cropImage==null){
      return;
    }
    final newFile = File(cropImage.path);
    emit(ProfileLoading());
    final result = await UpdateProfilePhotoUseCase().call(newFile);
    if (result is DataSuccess) {
      emit(ProfileSuccess());
      return;
    }
    if (result is DataFailed) {
      emit(ProfileError(result.error ?? 'Something went wrong'));
    }
  }
}
