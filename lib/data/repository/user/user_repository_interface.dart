import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../model/user_dto.dart';

abstract class UserRepositoryInterface {
  Future<UserDto> getCurrentUser();

  Future<UserDto?> getUserById(String id);
  Future<List<UserDto>> getUserAssignee();

  Future<UserDto> updateUser(UserDto payload);
  Future<String> uploadFile(File file);
}
