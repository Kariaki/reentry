import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';

import '../../../../data/model/client_dto.dart';
import '../../../../data/repository/admin/admin_repository.dart';
import '../../../../data/repository/appointment/appointment_repository.dart';
import '../../../../data/repository/clients/client_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../citizens/bloc/citizen_profile_cubit.dart';
import '../../shared/cubit_state.dart';
import 'mentor_state.dart';

class RemovedCareTeamFromOrganizationSuccess extends CubitState {}

class CareTeamProfileCubit extends HydratedCubit<CareTeamProfileCubitState> {
  CareTeamProfileCubit() : super(CareTeamProfileCubitState.init());

  final _appointmentRepo = AppointmentRepository();
  final _repo = AdminRepository();
  final _userRepository = UserRepository();
  final _orgRepo = OrganizationRepository();
  final _clientRepo = ClientRepository();

  void selectCurrentUser(UserDto user) {
    emit(state.success(user: user));
  }

  Future<void> removeFromOr(String userId, String orgId) async {
    print('reentry orgId -> ${userId}');
    emit(state.loading());
    try {
      await _orgRepo.removeFromOrganization(orgId, userId);
      emit(state.success(state: RemovedCareTeamFromOrganizationSuccess()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> unmatch(String userId, String clientId) async {
    try {
      emit(state.loading());
      ClientDto? client = await _clientRepo.getClientById(clientId);
      if (client != null) {
        client = client.copyWith(
            assignees: client.assignees.where((e) => e != userId).toList());
        await _clientRepo.updateClient(client);
      }
      final result = await _clientRepo.getUserClients(userId: userId);
      emit(state.success(citizens: result.map((e) => e.toUserDto()).toList()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
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

      final orgs =
          []; // await _orgRepo.getAllOrganizationsByIds(user.organizations);
      final citizens = client.map((e) => e.toUserDto());
      emit(state.success(
          citizens: citizens.toList(), appointments: appointments, orgs: []));
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace);
      print(e.toString());
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

  @override
  CareTeamProfileCubitState? fromJson(Map<String, dynamic> json) {
    return CareTeamProfileCubitState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(CareTeamProfileCubitState state) {
    return state.toJson();
  }
}
