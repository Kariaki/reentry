import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';
import 'package:reentry/ui/modules/admin/admin_stat_state.dart';

class AdminStatCubit extends Cubit<AdminStatCubitState> {
  AdminStatCubit() : super(AdminStatInitial());

  final _repo = AdminRepository();

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


