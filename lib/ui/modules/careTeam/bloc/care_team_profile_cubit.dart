import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';

import '../../../../data/repository/admin/admin_repository.dart';
import '../../../../data/repository/appointment/appointment_repository.dart';
import '../../../../data/repository/clients/client_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../citizens/bloc/citizen_profile_cubit.dart';
import 'mentor_state.dart';

class CareTeamProfileCubit extends Cubit<CareTeamProfileCubitState> {
  CareTeamProfileCubit() : super(CareTeamProfileCubitState.init());

  final _appointmentRepo = AppointmentRepository();
  final _repo = AdminRepository();
  final _userRepository = UserRepository();
  final _orgRepo = OrganizationRepository();

  void selectCurrentUser(UserDto user) {
    emit(state.success(user: user));
  }

  Future<void> init() async {
    final user = state.user;
    if (user == null) {
      return;
    }

    emit(state.loading());
    try {
      final client =
          await ClientRepository().getUserClients(userId: user.userId ?? '');
      final appointments =
          await _appointmentRepo.getAppointments(userId: user.userId ?? '');

      final orgs = await _orgRepo.getAllOrganizationsByIds(user.organizations);
      final citizens = client.map((e) => e.toUserDto());
      emit(state.success(
          citizens: citizens.toList(), appointments: appointments, orgs: orgs));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> deleteAccount(String userId, String reason) async {
    emit(state.loading());
    try {
      await _userRepository.deleteAccount(userId, reason);
      emit(state.success(state: AdminDeleteUserSuccess()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> updateProfile(UserDto user) async {
    try {
      emit(state.loading());
      await _userRepository.updateUser(user);
      emit(state.success(user: user, state: UpdateCitizenProfileSuccess()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
