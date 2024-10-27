import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

import '../../../../data/model/appointment_dto.dart';
import 'appointment_event.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(_createAppointment);
    on<UpdateAppointmentEvent>(_updateAppointment);
    on<CancelAppointmentEvent>(_cancelAppointment);
  }

  final _repo = AppointmentRepository();

  Future<void> _createAppointment(
      CreateAppointmentEvent payload, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentLoading());
      //_repo.createAppointment();
      final result = await _repo.createAppointment(payload);

      emit(AppointmentSuccess(result));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }

  Future<void> _updateAppointment(UpdateAppointmentEvent appointment,
      Emitter<AppointmentState> emit) async {}

  Future<void> _cancelAppointment(
      CancelAppointmentEvent event, Emitter<AppointmentState> emit) async {}
}
