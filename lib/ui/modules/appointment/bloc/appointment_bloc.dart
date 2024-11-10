import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'appointment_event.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(_createAppointment);
    on<CancelAppointmentEvent>(_cancelAppointment);
  }

  final _repo = AppointmentRepository();

  Future<void> _createAppointment(
      CreateAppointmentEvent payload, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentLoading());
      final result = await _repo.createAppointment(payload);
      emit(AppointmentSuccess(result));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _cancelAppointment(
      CancelAppointmentEvent event, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentLoading());
      await _repo.cancelAppointment(event.appointmentId);
      emit(CancelAppointmentSuccess());
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
