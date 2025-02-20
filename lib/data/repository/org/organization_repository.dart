import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import '../../enum/account_type.dart';
import '../../model/user_dto.dart';

class OrganizationRepository {
  final collection = FirebaseFirestore.instance.collection("user");
  final repository = UserRepository();

  Future<UserDto?> findOrganizationByCode(String code) async {
    final doc = collection.where("userCode", isEqualTo: code).where(
        UserDto.keyAccountType,
        isEqualTo: AccountType.reentry_orgs.name);
    final result = await doc.get();
    final document = result.docs.firstOrNull;
    if (document == null) {
      return null;
    }
    if (document.exists) {
      return UserDto.fromJson(document.data());
    }
    return null;
  }

  Future<UserDto?> removeFromOrganization(String orgId, String userId) async {
    UserDto? user = await repository.getUserById(userId);
    if (user == null) {
      throw Exception("User not found");
    }
    user = user.copyWith(
        organizations: user.organizations.where((e) => e != orgId).toList());
    print('update user -> ${user.organizations}');
    await repository.updateUser(user);
    return user;
  }

  Future<List<UserDto>> getCareTeamByOrganization(String orgId) async {
    final doc = await collection
        .where("organizations", arrayContains: orgId)
        .where(UserDto.keyDeleted, isEqualTo: false)
        .where(UserDto.keyAccountType, isNotEqualTo: AccountType.citizen.name)
        .get();
    return doc.docs.map((e) => UserDto.fromJson(e.data())).toList();
  }

  Future<List<UserDto>> getCitizensByOrganization(String orgId) async {
    final doc = await collection
        .where("organizations", arrayContains: orgId)
        .where(UserDto.keyDeleted, isNotEqualTo: true)
        .where(UserDto.keyAccountType, isEqualTo: AccountType.citizen.name)
        .get();
    return doc.docs.map((e) => UserDto.fromJson(e.data())).toList();
  }

  Future<List<UserDto>> getOrganizationsOfCareTeam(UserDto user) async {
    // if (user.organizations.isEmpty) {
    //   return [];
    // }
    final doc = await collection
        // .where("userId", whereIn: user.organizations)
        .where(UserDto.keyAccountType,
            isEqualTo: AccountType.reentry_orgs.name)
        .get();
    return doc.docs.map((e) => UserDto.fromJson(e.data())).toList();
  }
  //
  // Future<void> matchCareTeamToOrg(String orgId) async {
  //   final doc = await collection
  //       .where(UserDto.keyDeleted, isEqualTo: false)
  //       .where(UserDto.keyAccountType, isNotEqualTo: AccountType.citizen.name)
  //       .get();
  //   final teams = doc.docs
  //       .map((e) {
  //         UserDto user =
  //             UserDto.fromJson(e.data()).copyWith(organizations: [orgId]);
  //         return user;
  //       })
  //       .where((e) =>
  //           e.accountType != AccountType.admin &&
  //           e.accountType != AccountType.reentry_orgs)
  //       .toList();
  //
  //   for (int i = 0; i < 5; i++) {
  //     final team = teams[i].copyWith(organizations: [orgId]);
  //     await repository.updateUser(team);
  //     print(
  //         'reentry org -> ${team.userId} -> ${team.organizations} -> ${team.accountType.name}');
  //   }
  // }
}
