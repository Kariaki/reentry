import 'package:reentry/ui/modules/shared/cubit_state.dart';

sealed class AdminStatCubitState {

}
class AdminStatLoading extends AdminStatCubitState{}
class AdminStatError extends AdminStatCubitState{
  final String error;
  AdminStatError(this.error);
}
class AdminStatSuccess extends AdminStatCubitState{
  final AdminStatEntity data;
  AdminStatSuccess(this.data);
}
class AdminStatInitial extends AdminStatCubitState{}
class AdminStatEntity{
  final int totalCitizens;
  final int careTeam;
  final int appointments;
  const AdminStatEntity({required this.appointments,required this.careTeam,required this.totalCitizens});
}