import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_cubit.dart';

sealed class AppointmentGraphState{}
class AppointmentGraphInitial extends AppointmentGraphState{}
class AppointmentGraphLoading extends AppointmentGraphState{}
class AppointmentGraphError extends AppointmentGraphState{
  final String error;
  AppointmentGraphError(this.error);
}
class AppointmentGraphSuccess extends AppointmentGraphState{

  final List<int> data;
  final int appointmentCount;
  AppointmentGraphSuccess(this.data,this.appointmentCount);
}