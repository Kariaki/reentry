import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_state.dart';

import '../../../../core/util/graph_data.dart';
import '../../../../data/model/appointment_dto.dart';

class AppointmentGraphCubit extends Cubit<AppointmentGraphState> {
  AppointmentGraphCubit() : super(AppointmentGraphInitial());

  Future<void> appointmentGraphData({String? userId,List<NewAppointmentDto>? appointment}) async {

    try {
      if(appointment!=null){

        final timeline = appointment.map((e) => e.date.millisecondsSinceEpoch).toList();

        final monthlyGraphData = GraphData().monthlyYAxis(timeline);
        emit(AppointmentGraphSuccess(monthlyGraphData,appointment.length));
        return;
      }
      emit(AppointmentGraphLoading());
      final appointments =
          await AppointmentRepository().getAppointments(userId: userId);

      final timeline = appointments.map((e) => e.date.millisecondsSinceEpoch).toList();

      final monthlyGraphData = GraphData().monthlyYAxis(timeline);
      emit(AppointmentGraphSuccess(monthlyGraphData,appointments.length));
    } catch (e) {
      emit(AppointmentGraphError(e.toString()));
    }
  }
}
