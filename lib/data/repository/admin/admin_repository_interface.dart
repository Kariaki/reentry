import 'package:reentry/ui/modules/authentication/account_type_screen.dart';

import '../../enum/account_type.dart';

abstract class AdminRepositoryInterface{
  Future<void> getUsers(AccountType type);
  Future<void> getAllAppointments();
  Future<void> publishResources();
  Future<void> deleteUser();
  Future<void> updateUser();
  Future<void> matchUser();
  Future<void> fetchReports();

}