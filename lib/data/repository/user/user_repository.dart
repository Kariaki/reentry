import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/user/user_repository_interface.dart';
import 'package:reentry/exception/app_exceptions.dart';

class UserRepository extends UserRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("user");

  @override
  Future<UserDto> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<UserDto?> getUserById(String id) async {
    final doc = collection.doc(id);
    final result = await doc.get();
    if (result.exists) {
      return UserDto.fromJson(result.data() ?? {});
    }
    return null;
  }

  @override
  Future<UserDto> updateUser(UserDto payload) async {
    try {
      final doc = collection.doc(payload.userId!);
      await doc.set(payload.toJson());
      return payload;
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
