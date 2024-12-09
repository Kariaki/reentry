import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import '../../../../data/repository/appointment/appointment_repository.dart';

class AppointmentCubit extends Cubit<AppointmentCubitState> {
  final _repo = AppointmentRepository();

  AppointmentCubit() : super(AppointmentCubitState.init());

  Future<void> fetchAppointmentInvitations(String userId) async {
    emit(state.loading());
    try {
      final currentUser = await PersistentStorage.getCurrentUser();

      final result =
          await _repo.getUserAppointmentInvitations(currentUser?.userId ?? '');
      result.listen((event) {
        emit(state.success(invitations: event));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> fetchAppointments(
    String userId,
  ) async {
    emit(state.loading());
    try {
      final currentUser = await PersistentStorage.getCurrentUser();

      final result =
          await _repo.getCurrentUserAppointments(currentUser?.userId ?? '');
      result.listen((event) {
        List<NewAppointmentDto> today = [];
        if (kIsWeb) {
          today = event
              .where((e) => e.date.formatDate() == DateTime.now().formatDate())
              .toList();
        }
        emit(state.success(data: event, appointmentForToday: today));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}

class UserAppointmentCubit extends Cubit<AppointmentState> {
  final _repo = AppointmentRepository();

  UserAppointmentCubit() : super(AppointmentInitial());

  Future<void> getAppointmentsByUserId(String id) async {
    emit(AppointmentLoading());
    try {
      final result = await _repo.getCurrentUserAppointments(id);
      emit(UserAppointmentDataSuccess([]));
    } catch (e) {
      emit(AppointmentError(e.toString()));
    }
  }
}
