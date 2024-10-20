import '../../model/user_dto.dart';

abstract class UserRepositoryInterface {
  Future<UserDto> getCurrentUser();

  Future<UserDto> getUserById(String id);

  Future<UserDto> updateUser(UserDto payload);
}
