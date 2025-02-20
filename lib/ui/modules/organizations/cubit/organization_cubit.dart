import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class OrganizationCubit extends Cubit<OrganizationCubitState> {
  OrganizationCubit() : super(OrganizationCubitState(state: CubitState()));

  final _repo = OrganizationRepository();

  Future<void> fetchOrganizations() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    if (user.accountType == AccountType.reentry_orgs ||
        user.accountType == AccountType.admin ||
        user.accountType == AccountType.citizen) {
      return;
    }
    try {
      emit(state.loading());

      final result = await _repo.getOrganizationsOfCareTeam(user);
      emit(state.success(data: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> findOrganizationByCode(String code) async {
    try {
      emit(state.loading());
      final result = await _repo.findOrganizationByCode(code);
      final careTeams =
          await _repo.getCareTeamByOrganization(result?.userId ?? '');
      final citizens =
          await _repo.getCitizensByOrganization(result?.userId ?? '');
      emit(state.success(
          foundOrganization: FoundOrganization(
              careTeam: careTeams.length,
              citizens: citizens.length,
              data: result!)));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void selectOrganization(UserDto selected) {
    emit(state.success(selectedOrganization: selected));
  }
}
