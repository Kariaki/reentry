import 'package:reentry/data/model/appointment_dto.dart';

class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  final String? note;
  final int timestamp;
  final String userId;
  final String notes;

  CreateAppointmentEvent(
      {this.note, required this.timestamp, required this.userId,required this.notes});

  AppointmentDto toAppointmentDto() {
    return AppointmentDto(id: '', time: timestamp, attendees: [userId],note: notes);
  }
}

class UpdateAppointmentEvent extends AppointmentEvent {}

class CancelAppointmentEvent extends AppointmentEvent {}
