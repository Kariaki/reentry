import 'dart:io';
import 'package:reentry/core/resources/data_state.dart';
import 'package:reentry/core/usecase/usecase.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';

class UpdateProfilePhotoUseCase extends UseCase<DataState<void>, File> {
  final _repo = UserRepository();

  @override
  Future<DataState<void>> call(File params) async {
    try {
      final currentUser = await PersistentStorage.getCurrentUser();
      if (currentUser == null) {
        return const DataFailed('No user found');
      }
      final url = await _repo.uploadFile(params);
      final user = currentUser.copyWith(avatar: url);
      await _repo.updateUser(user);
      await PersistentStorage.cacheUserInfo(user);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
