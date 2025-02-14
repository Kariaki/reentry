import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/resources/data_state.dart';
import 'package:reentry/core/util/image_util.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/domain/usecases/user/update_profile_photo_usecase.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../data/shared/share_preference.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());
  final _repo = UserRepository();

  Future<void> deleteAccount(String userId, String reason) async {
    emit(ProfileLoading());
    try {
      await _repo.deleteAccount(userId, reason);
      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfilePhoto(XFile file) async {
    final cropImage = await ImageUtil.cropImage(file, true);
    if (cropImage == null) {
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

  Future<void> registerPushNotificationToken() async {
    _repo.registerPushNotificationToken();
  }

  Future<void> updateSettings(UserSettings settings) async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    final result = user.copyWith(settings: settings);
    await PersistentStorage.cacheUserInfo(result);
    emit(SettingsUpdateSuccess(result));
    updateProfile(result);
  }

  Future<void> updateProfile(UserDto user, {bool ignoreStorage = false}) async {
    emit(ProfileLoading());
    try {
      await _repo.updateUser(user);
      if (!ignoreStorage) {
        await PersistentStorage.cacheUserInfo(user);
      }
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> submitIntakeForm(String userId, IntakeForm form) async {
    emit(ProfileLoading());
    try {
      UserDto? user = await _repo.getUserById(userId);
      if (user == null) {
        emit(ProfileError('User not found'));
        return;
      }
     user =  user.copyWith(intakeForm: form);
      await _repo.updateUser(user);
      emit(IntakeFormSuccess(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
