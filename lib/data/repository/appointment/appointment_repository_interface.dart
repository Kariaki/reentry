import '../../../ui/modules/appointment/bloc/appointment_event.dart';
import '../../model/appointment_dto.dart';

abstract class AppointmentRepositoryInterface{
  Future<AppointmentDto> createAppointment(CreateAppointmentEvent payload);
  Future<List<AppointmentEntityDto>> getUserAppointments();
  Future<AppointmentDto> updateAppointment(AppointmentDto payload);
  Future<void> deleteAppointment(String id);
}