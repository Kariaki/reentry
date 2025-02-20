import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class OrganizationProfileCubitState {
  final UserDto? organization;
  final int? totalCitizens;
  final int? totalCareTeam;
  final CubitState state;

  OrganizationProfileCubitState(
      {this.organization,
      this.totalCitizens,
      this.totalCareTeam,
      required this.state});

  OrganizationProfileCubitState loading() => OrganizationProfileCubitState(
      state: CubitStateLoading(),
      totalCareTeam: totalCareTeam,
      totalCitizens: totalCitizens,
      organization: organization);

  OrganizationProfileCubitState success(
          {int? citizens, int? careTeam, UserDto? organization}) =>
      OrganizationProfileCubitState(
          state: CubitStateSuccess(),
          totalCitizens: citizens ?? totalCitizens,
          totalCareTeam: careTeam ?? totalCareTeam,
          organization: organization ?? this.organization);

  OrganizationProfileCubitState error(String message) =>
      OrganizationProfileCubitState(
          state: CubitStateError(message),
          totalCareTeam: totalCareTeam,
          totalCitizens: totalCitizens,
          organization: organization);
}
