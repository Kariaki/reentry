import 'package:reentry/data/model/appointment_dto.dart';

class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  final NewAppointmentDto data;

  CreateAppointmentEvent(this.data);
}

class UpdateAppointmentEvent extends AppointmentEvent {}

class CancelAppointmentEvent extends AppointmentEvent {
  final String appointmentId;

  CancelAppointmentEvent(this.appointmentId);
}
