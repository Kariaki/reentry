import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/user/user_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/exception/app_exceptions.dart';

class UserRepository extends UserRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("user");

  final _clientCollection = FirebaseFirestore.instance.collection("clients");

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

  @override
  Future<List<UserDto>> getUserAssignee() async {
    final currentUser = await PersistentStorage.getCurrentUser();
    if (currentUser == null) {
      return [];
    }
    final clientDoc = await _clientCollection.doc(currentUser.userId).get();
    if (!clientDoc.exists) {
      return [];
    }
    final map = clientDoc.data();
    final userClient = ClientDto.fromJson(map!);
    final assignees = userClient.assignees;
    if (assignees.isEmpty) {
      return [];
    }
    final assigneeUserList =
        await collection.where(UserDto.keyUserId, whereIn: assignees).get();
    return assigneeUserList.docs
        .map((e) => UserDto.fromJson(e.data()))
        .toList();
  }
}
