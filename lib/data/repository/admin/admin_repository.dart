import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/admin/admin_repository_interface.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/ui/modules/admin/admin_stat_state.dart';

class AdminRepository implements AdminRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  Future<List<UserDto>> getUsers(AccountType type) async {
    final result = await collection
        .where(UserDto.keyAccountType, isEqualTo: type.name)
        .where(UserDto.keyDeleted, isNotEqualTo: true)
        .get();
    final output = result.docs.map((e) {
      return UserDto.fromJson(e.data());
    }).toList();
    return output;
  }

  Future<List<UserDto>> getAllCareTeam() async {
    final result = await collection
        // .where(UserDto.keyAccountType, isNotEqualTo: AccountType.admin.name)
        .where(UserDto.keyAccountType, isNotEqualTo: AccountType.citizen.name)
        //.where(UserDto.keyDeleted, isNotEqualTo: true)
        .get();
    final output = result.docs.map((e) {
      return UserDto.fromJson(e.data());
    }).toList();
    return output;
  }

  Future<AdminStatEntity> fetchStats() async {
    final citizens = await getUsers(AccountType.citizen);
    final careTeam = await getNonCitizens();
    final appointments = await AppointmentRepository().getAppointments();
    return AdminStatEntity(
        appointments: appointments.length,
        careTeam: careTeam.length,
        totalCitizens: citizens.length);
  }

  Future<List<UserDto>> getNonCitizens() async {
    final result = await collection
        .where(UserDto.keyAccountType, isNotEqualTo: AccountType.citizen.name)
        //.where(UserDto.keyAccountType, isNotEqualTo: AccountType.admin.name)
        .get();
    final output = result.docs.map((e) {
      return UserDto.fromJson(e.data());
    }).toList();
    return output;
  }
}
