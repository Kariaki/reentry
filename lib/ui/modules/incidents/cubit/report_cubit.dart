import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/repository/report/report_repository.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit_state.dart';

import '../../../../data/enum/account_type.dart';

class ReportCubit extends Cubit<ReportCubitState> {
  ReportCubit() : super(ReportCubitState.init());

  final _repository = ReportRepository();

  Future<void> fetchReports() async {
    try {
      emit(state.loading());
      final result = await _repository.getReports();

      emit(state.success(data: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void select(IncidenceDto report){
    emit(state.success(selected: report));
  }
  Future<void> submitResponse(IncidenceResponse response) async {}

  Future<void> fetchResponses(String reportId) async {
    try {
      emit(state.loading());
      final result = await _repository.getIncidenceResponse(reportId);
      emit(state.success(responses: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
