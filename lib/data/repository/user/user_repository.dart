import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/user/user_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/domain/firebase_api.dart';
import 'package:reentry/exception/app_exceptions.dart';

class UserRepository extends UserRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("user");

  final _clientCollection = FirebaseFirestore.instance.collection("clients");

  @override
  Future<UserDto> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  Future<void> deleteAccount(String userId, String reason) async {
    final doc = collection.doc(userId);
    final result = await doc.get();
    if (result.exists) {
      final userCred = UserDto.fromJson(result.data() ?? {})
          .copyWith(reasonForAccountDeletion: reason, deleted: true);
      await _clientCollection.doc(userId).delete();
      await doc.set(userCred.toJson());
      return;
    }
    throw BaseExceptions("user not found");
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

  Future<List<UserDto>> getUsersByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    final doc = await collection
        .where(UserDto.keyUserId, whereIn: ids)
       .where(UserDto.keyDeleted, isNotEqualTo: true)
        .get();
    return doc.docs.map((e) => UserDto.fromJson(e.data())).toList();
  }


  Future<void> registerPushNotificationToken() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      throw BaseExceptions('User not found');
    }

    final token = await FirebaseApi.getToken();
    if (token == null) {
      throw BaseExceptions('Unable to get token');
    }
    try {
      final doc = collection.doc(user.userId!);
      await doc.set(user.copyWith(pushNotificationToken: token).toJson());
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }

  @override
  Future<UserDto> updateUser(UserDto payload) async {
    try {
      final doc = collection.doc(payload.userId!);
      if(payload.accountType==AccountType.citizen){
       ClientDto? client = await  ClientRepository().getClientById(payload.userId??'');
       client = client?.copyWith(name: payload.name,avatar: payload.avatar,email: payload.email);
       if(client!=null) {
        await ClientRepository().updateClient(client);
       }
      }
      await doc.set(payload.toJson());
      return payload;
    } catch (e) {
      print(e.toString());
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

  @override
  Future<String> uploadFile(File file) async {
    // Create a Reference to the file
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('sainte')
          .child('/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );

      final result = await ref.putFile(File(file.path), metadata);
      if (result.state == TaskState.success) {
        final url = await ref.getDownloadURL();
        return url;
      }
      throw BaseExceptions('Something went wrong');
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
