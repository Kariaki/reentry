import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class CitizenProfileCubitState {
  final List<UserDto> careTeam;
  final List<NewAppointmentDto> appointments;
  final UserDto? user;
  final ClientDto? client;
  final CubitState state;

  const CitizenProfileCubitState(
      {this.client,
      this.user,
      this.appointments = const [],
      this.careTeam = const [],
      required this.state});

  static CitizenProfileCubitState init() =>
      CitizenProfileCubitState(state: CubitState());

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'client': client?.toJson(),
      'careTeam': careTeam.map((e) => e.toJson()).toList(),
      'appointments': appointments.map((e) => e.toJson()).toList()
    };
  }

  factory CitizenProfileCubitState.fromJson(Map<String, dynamic> json) {
    return CitizenProfileCubitState(
        client: ClientDto.fromJson(json['client']),
        careTeam: (json['careTeam'] as List<dynamic>)
            .map((e) => UserDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        appointments: (json['appointments'] as List<dynamic>)
            .map((e) => NewAppointmentDto.fromJson(e as Map<String, dynamic>,""))
            .toList(),
        state: CubitStateSuccess(),
        user: UserDto.fromJson(json['user']));
  }

  CitizenProfileCubitState error(String message) => CitizenProfileCubitState(
      state: CubitStateError(message),
      appointments: appointments,
      user: user,
      client: client,
      careTeam: careTeam);

  CitizenProfileCubitState loading({CubitState? state}) =>
      CitizenProfileCubitState(
          state: state ?? CubitStateLoading(),
          appointments: appointments,
          user: user,
          client: client,
          careTeam: careTeam);

  CitizenProfileCubitState success(
          {List<UserDto>? careTeam,
          List<NewAppointmentDto>? appointmentCount,
          ClientDto? client,
          CubitState? state,
          UserDto? user}) =>
      CitizenProfileCubitState(
          state: state ?? CubitStateSuccess(),
          appointments: appointmentCount ?? this.appointments,
          user: user ?? this.user,
          client: client ?? this.client,
          careTeam: careTeam ?? this.careTeam);
}
