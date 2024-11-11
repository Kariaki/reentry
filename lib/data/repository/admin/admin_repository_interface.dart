import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';

abstract class AdminRepositoryInterface {
  Future<List<UserDto>> getUsers(AccountType type);

  // Future<void> getAllAppointments();
  //
  // Future<void> publishResources();
  //
  // Future<void> deleteUser();
  //
  // Future<void> updateUser();
  //
  // Future<void> matchUser();
  //
  // Future<void> fetchReports();
}
