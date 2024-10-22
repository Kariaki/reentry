import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/util/bloc/utility_event.dart';
import 'package:reentry/ui/modules/util/bloc/utility_state.dart';

class UtilityBloc extends Bloc<UtilityEvent, UtilityState> {
  UtilityBloc() : super(UtilityInitial()) {
    on<SupportTicketEvent>(_reportUser);
    on<ReportUserEvent>(_supportTicket);
  }

  Future<void> _reportUser(
      UtilityEvent event, Emitter<UtilityState> emit) async {}

  Future<void> _supportTicket(
      UtilityEvent event, Emitter<UtilityState> emit) async {}
}
