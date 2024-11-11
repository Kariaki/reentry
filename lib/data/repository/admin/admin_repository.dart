import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/admin/admin_repository_interface.dart';

class AdminRepository implements AdminRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  Future<List<UserDto>> getUsers(AccountType type) async {
    final result =
        await collection.where(UserDto.keyUserId, isEqualTo: type.name).get();
    return result.docs.map((e) {
      return UserDto.fromJson(e.data());
    }).toList();
  }
}
