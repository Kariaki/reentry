import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentDataSuccess extends AppointmentState {
  List<NewAppointmentDto> data;

  AppointmentDataSuccess(this.data);
}

class UserAppointmentDataSuccess extends AppointmentState {
  List<NewAppointmentDto> data;

  UserAppointmentDataSuccess(this.data);
}

class AppointmentSuccess extends AppointmentState {
  NewAppointmentDto data;

  AppointmentSuccess(this.data);
}

class AppointmentLoading extends AppointmentState {}

class CancelAppointmentSuccess extends AppointmentState {}

class UpdateAppointmentSuccess extends AppointmentState {
  NewAppointmentDto data;

  UpdateAppointmentSuccess(this.data);
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}

class AppointmentCubitState {
  List<NewAppointmentDto> data;
  List<NewAppointmentDto> invitations;
  List<NewAppointmentDto> appointmentForToday;
  CubitState state;

  AppointmentCubitState(
      {this.data = const [], this.invitations = const [], this.appointmentForToday = const [], required this.state});

  static AppointmentCubitState init() => AppointmentCubitState(
        state: CubitState(),
      );

  AppointmentCubitState loading() => AppointmentCubitState(
      state: CubitStateLoading(), data: data, invitations: invitations);

  AppointmentCubitState success(
          {List<NewAppointmentDto>? data,List<NewAppointmentDto>? appointmentForToday,
          List<NewAppointmentDto>? invitations}) =>
      AppointmentCubitState(
          data: data ?? this.data,
          appointmentForToday:appointmentForToday??this.appointmentForToday,
          invitations: invitations ?? this.invitations,
          state: CubitStateSuccess());

  AppointmentCubitState error(String message) => AppointmentCubitState(
        state: CubitStateError(message),
        data: data,
        invitations: invitations,
      );
}
