import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';
import 'package:reentry/ui/modules/admin/admin_stat_state.dart';

class AdminStatCubit extends Cubit<AdminStatCubitState> {
  AdminStatCubit() : super(AdminStatInitial());

  final _repo = AdminRepository();

  void updateStat(AdminStatEntity entity) {
    emit(AdminStatSuccess(entity));
  }

  void updateAppointment() async {
    final value = state;
    if (value is AdminStatSuccess) {
      emit(AdminStatSuccess(
          value.data.copyWith(appointments: value.data.appointments + 1)));
    }
  }

  Future<void> fetchStats() async {
    try {
      emit(AdminStatLoading());
      final result = await _repo.fetchStats();
      emit(AdminStatSuccess(result));
    } catch (e) {
      emit(AdminStatError(e.toString()));
    }
  }
}
