import 'package:reentry/data/model/appointment_dto.dart';

class AppointmentState {}
class AppointmentInitial extends AppointmentState {}

class AppointmentDataSuccess extends AppointmentState {
  List<AppointmentEntityDto> data;

  AppointmentDataSuccess(this.data);
}
class AppointmentSuccess extends AppointmentState{
  AppointmentDto data;

  AppointmentSuccess(this.data);
}
class AppointmentLoading extends AppointmentState {}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}
