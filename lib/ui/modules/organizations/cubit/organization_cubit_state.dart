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
  final List<UserDto> all;
  final UserDto? selectedOrganization;
  final FoundOrganization? foundOrganization;

  OrganizationCubitState(
      {required this.state,
      this.data = const [],
      this.all = const [],
      this.selectedOrganization,
      this.foundOrganization});

  OrganizationCubitState loading() => OrganizationCubitState(
      state: CubitStateLoading(),
      data: data,
      all: all,
      selectedOrganization: selectedOrganization,
      foundOrganization: null);

  OrganizationCubitState success({
    List<UserDto>? data,
    List<UserDto>? all,
    UserDto? selectedOrganization,
    FoundOrganization? foundOrganization,
  }) =>
      OrganizationCubitState(
          state: CubitStateSuccess(),
          data: data ?? this.data,
          all: all ?? this.all,
          selectedOrganization:
              selectedOrganization ?? this.selectedOrganization,
          foundOrganization: foundOrganization ?? this.foundOrganization);

  OrganizationCubitState error(String error) => OrganizationCubitState(
      state: CubitStateError(error), data: data, all: all);
}

class OrganizationMembersCubitState {
  final CubitState? state;
  final List<UserDto> data;

  const OrganizationMembersCubitState({ this.state, this.data = const []});

  OrganizationMembersCubitState loading() {
    return OrganizationMembersCubitState(state: CubitStateLoading(), data: data);
  }

  OrganizationMembersCubitState error(String message) {
    return OrganizationMembersCubitState(state: CubitStateError(message), data: data);
  }

  OrganizationMembersCubitState success(List<UserDto> data) {
    return OrganizationMembersCubitState(state: CubitStateSuccess(), data: data);
  }
}
