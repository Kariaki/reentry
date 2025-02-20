import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class FoundOrganization {
  final UserDto data;
  final int citizens;
  final int careTeam;

  FoundOrganization(
      {required this.careTeam, required this.citizens, required this.data});
}

class OrganizationCubitState {
  final CubitState state;
  final List<UserDto> data;
  final UserDto? selectedOrganization;
  final FoundOrganization? foundOrganization;

  OrganizationCubitState(
      {required this.state,
      this.data = const [],
      this.selectedOrganization,
      this.foundOrganization});

  OrganizationCubitState loading() => OrganizationCubitState(
      state: CubitStateLoading(),
      data: data,
      selectedOrganization: selectedOrganization,
      foundOrganization: null);

  OrganizationCubitState success({
    List<UserDto>? data,
    UserDto? selectedOrganization,
    FoundOrganization? foundOrganization,
  }) =>
      OrganizationCubitState(
          state: CubitStateSuccess(),
          data: data ?? this.data,
          selectedOrganization:
              selectedOrganization ?? this.selectedOrganization,
          foundOrganization: foundOrganization ?? this.foundOrganization);

  OrganizationCubitState error(String error) =>
      OrganizationCubitState(state: CubitStateError(error),data: data);
}
