import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/admin/admin_repository_interface.dart';

class AdminRepository implements AdminRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  Future<List<UserDto>> getUsers(AccountType type) async {
    final result =
        await collection.where(UserDto.keyAccountType, isEqualTo: type.name).get();
    final output =  result.docs.map((e) {
      return UserDto.fromJson(e.data());
    }).toList();
    print('users fetched -> ${output.length}');
    return output;
  }
}
