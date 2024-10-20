import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/user/user_repository_interface.dart';

class UserRepository extends UserRepositoryInterface{

  final collection = FirebaseFirestore.instance.collection("user");

  @override
  Future<UserDto> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<UserDto> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<UserDto> updateUser(UserDto payload) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}