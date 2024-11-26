import 'package:reentry/data/model/appointment_dto.dart';

class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  final NewAppointmentDto data;

  CreateAppointmentEvent(this.data);
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final NewAppointmentDto data;

  UpdateAppointmentEvent(this.data);
}

class CancelAppointmentEvent extends AppointmentEvent {
  final NewAppointmentDto data;

  CancelAppointmentEvent(this.data);
}
