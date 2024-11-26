import 'package:reentry/data/model/appointment_dto.dart';

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
class AppointmentSuccess extends AppointmentState{
  NewAppointmentDto data;

  AppointmentSuccess(this.data);
}
class AppointmentLoading extends AppointmentState {}

class CancelAppointmentSuccess extends AppointmentState{}
class UpdateAppointmentSuccess extends AppointmentState{
  NewAppointmentDto data;
  UpdateAppointmentSuccess(this.data);
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}
