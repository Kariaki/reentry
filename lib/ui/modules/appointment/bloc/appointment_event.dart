import 'package:reentry/data/model/appointment_dto.dart';

class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  final String? note;
  final int timestamp;
  final String userId;
  final int bookedDay;
  final String bookedTime;
  final String notes;
  final String? id;
  final AppointmentStatus? status;

  CreateAppointmentEvent(
      {this.note,
      required this.timestamp,
      required this.userId,
      this.status,
      this.id,
      required this.notes,
      required this.bookedDay,
      required this.bookedTime});

  AppointmentDto toAppointmentDto() {
    return AppointmentDto(
        id: id ?? '',
        time: timestamp,
        attendees: [userId],
        status: status ?? AppointmentStatus.upcoming,
        note: notes,
        bookedDay: bookedDay,
        bookedTime: bookedTime);
  }
}

class UpdateAppointmentEvent extends AppointmentEvent {}

class CancelAppointmentEvent extends AppointmentEvent {
  final String appointmentId;

  CancelAppointmentEvent(this.appointmentId);
}
