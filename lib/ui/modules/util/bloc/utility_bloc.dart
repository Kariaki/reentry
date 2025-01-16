import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/report/report_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/util/bloc/utility_event.dart';
import 'package:reentry/ui/modules/util/bloc/utility_state.dart';
import 'package:reentry/data/repository/util/util_repository.dart';

class UtilityBloc extends Bloc<UtilityEvent, UtilityState> {
  UtilityBloc() : super(UtilityInitial()) {
    on<SupportTicketEvent>(_supportTicket);
    on<ReportUserEvent>(_reportUser);
  }

  final _repo = UtilRepository();
  final _reportRepo = ReportRepository();

  Future<void> _reportUser(
      UtilityEvent event, Emitter<UtilityState> emit) async {
    emit(UtilityLoading());
    try {
      event as ReportUserEvent;

      await _reportRepo.reportUser(event.data);
      emit(UtilitySuccess());
    } catch (e) {
      emit(UtilityFailed(e.toString()));
    }
  }

  Future<void> _supportTicket(
      UtilityEvent event, Emitter<UtilityState> emit) async {
    emit(UtilityLoading());
    try {
      final value = event as SupportTicketEvent;
      await _repo.supportTicket(value.ticketDto());
      emit(SupportSuccess());
    } catch (e) {
      emit(SupportFailure(e.toString()));
    }
  }
}
