import 'package:reentry/data/model/user_dto.dart';

import '../../../../data/model/appointment_dto.dart';
import '../../../../data/model/mentor_request.dart';
import '../../shared/cubit_state.dart';

class MentorState {}

class MentorStateInitial extends MentorState {}

class MentorStateLoading extends MentorState {}

class MentorStateError extends MentorState {
  String message;

  MentorStateError(this.message);
}

class MentorLoaded extends MentorState {
  final UserDto mentor;

  MentorLoaded(this.mentor);
}

class MentorStateSuccess extends MentorState {
  MentorRequest data;

  MentorStateSuccess(this.data);
}

class CareTeamProfileCubitState {
  final List<UserDto> citizens;
  final List<UserDto> orgs;
  final List<NewAppointmentDto> appointments;
  final UserDto? user;
  final CubitState state;

  const CareTeamProfileCubitState(
      {this.user,
      this.appointments= const[],
        this.orgs = const [],
      this.citizens = const [],
      required this.state});

  static CareTeamProfileCubitState init() =>
      CareTeamProfileCubitState(state: CubitState());

  CareTeamProfileCubitState error(String message) => CareTeamProfileCubitState(
      state: CubitStateError(message),
      appointments: appointments,
      orgs: orgs,
      user: user,
      citizens: citizens);

  CareTeamProfileCubitState loading({CubitState? state}) =>
      CareTeamProfileCubitState(
          state: state ?? CubitStateLoading(),
          appointments: appointments,
          orgs: orgs,
          user: user,
          citizens: citizens);

  CareTeamProfileCubitState success(
          {List<UserDto>? citizens,List<UserDto>? orgs,
          List<NewAppointmentDto>? appointments,
          CubitState? state,
          UserDto? user}) =>
      CareTeamProfileCubitState(
          state: state ?? CubitStateSuccess(),
          orgs: orgs??this.orgs,
          appointments: appointments ?? this.appointments,
          user: user ?? this.user,
          citizens: citizens ?? this.citizens);
}
