import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/resources/data_state.dart';
import 'package:reentry/core/util/image_util.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/blog/blog_repository.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';
import 'package:reentry/domain/usecases/user/update_profile_photo_usecase.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../data/shared/share_preference.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());
  final _repo = UserRepository();

  final _orgRepo = OrganizationRepository();

  Future<void> deleteAccount(String userId, String reason) async {
    emit(ProfileLoading());
    try {
      await _repo.deleteAccount(userId, reason);
      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> removeFromOr(String userId, String orgId) async {
    print('reentry orgId -> ${userId}');
    emit(ProfileLoading());
    try {
      await _orgRepo.removeFromOrganization(orgId, userId);
      emit(RemovedFromOrganizationSuccess());
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

  Future<void> updateProfilePhotoWeb(Uint8List? file, UserDto user) async {
    emit(ProfileLoading());
    try {
      String? url;
      if (file != null) {
        url = await uploadFile(file);
      }
      user = user.copyWith(avatar: url);
      final result = await _repo.updateUser(user);
      await PersistentStorage.cacheUserInfo(user);
      emit(ProfileSuccess(user: result));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> registerPushNotificationToken() async {
    _repo.registerPushNotificationToken();
  }

  Future<void> updateProfile(UserDto user, {bool ignoreStorage = false}) async {
    emit(ProfileLoading());
    try {
      final result = await _repo.updateUser(user);
      if (!ignoreStorage) {
        await PersistentStorage.cacheUserInfo(user);
      }
      emit(ProfileSuccess(user: result));
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
      user = user.copyWith(intakeForm: form);
      await _repo.updateUser(user);
      emit(IntakeFormSuccess(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
