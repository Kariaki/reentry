import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';

import '../../../../data/model/appointment_dto.dart';
import '../../../../data/repository/appointment/appointment_repository.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final _repo = AppointmentRepository();

  AppointmentCubit() : super(AppointmentInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentLoading());
    //fetch appointment
    //
  }
}
