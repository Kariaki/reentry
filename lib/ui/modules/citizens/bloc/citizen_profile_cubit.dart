import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../data/model/mentor_request.dart';
import '../../../../data/repository/admin/admin_repository.dart';

class RefreshCitizenProfile extends CubitState {}

class AdminDeleteUserSuccess extends CubitState {}

class UpdateCitizenProfileSuccess extends CubitState {}

class DeleteCitizenProfileSuccess extends CubitState {}

class CitizenProfileCubit extends HydratedCubit<CitizenProfileCubitState> {
  CitizenProfileCubit() : super(CitizenProfileCubitState.init());

  final _appointmentRepo = AppointmentRepository();
  final _repo = AdminRepository();
  final _clientRepository = ClientRepository();
  final _userRepository = UserRepository();

  Future<void> deleteAccount(String userId, String reason) async {
    emit(state.loading());
    try {
      await _userRepository.deleteAccount(userId, reason);
      emit(state.success(state: AdminDeleteUserSuccess()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void setCurrentUser(UserDto user) {
    emit(state.success(user: user, client: user.toClient()));
  }

  Future<void> fetchCitizenProfileInfo(UserDto user1) async {
    List<UserDto> careTeam = [];
    List<NewAppointmentDto> appointmentCount = [];

    ClientDto? client;
    try {
      emit(state.loading());
      appointmentCount =
          (await _appointmentRepo.getAppointments(userId: user1.userId ?? ''));
      client = await _clientRepository.getClientById(user1.userId ?? '');
      final user = await _userRepository.getUserById(user1.userId ?? '');
      print('citizen-profile -> ${user?.toJson()}');
      if (user?.accountType == AccountType.admin ||
          user?.accountType == AccountType.citizen) {
        careTeam =
            await _userRepository.getUsersByIds((client?.assignees ?? []));
      }
      emit(state.success(
          careTeam: careTeam.where((e) => !e.deleted).toList(),
          user: user,
          appointmentCount: appointmentCount,
          client: client));
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace);
      emit(state.error(e.toString()));
      return;
    }
  }

  Future<void> updateAndRefreshCareTeam(
      List<String> newAssignees, List<String> orgs) async {
    try {
      emit(state.loading(state: RefreshCitizenProfile()));
      final account = state.user;
      final mentorRequest = MentorRequest(
          name: account?.name ?? '',
          avatar: account?.avatar ??
              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
          reasonForRequest: '',
          userId: account?.userId,
          whatYouNeedInAMentor: '',
          email: account?.email ?? '');
      final clientInfo = state.client ??
          mentorRequest.toClient().copyWith(
                status: ClientStatus.active,
              );
      final newClient = clientInfo.copyWith(assignees: newAssignees);

      await _clientRepository.updateClient(newClient);
      UserDto? user = await _userRepository.getUserById(account?.userId ?? '');
      if (user != null) {
        user = user.copyWith(organizations: orgs);
        print('kfind -> ${user.toJson()}');

        await _userRepository.updateUser(user);
      }

      final careTeam = await _userRepository.getUsersByIds(newAssignees);
      emit(state.success(
          careTeam: careTeam,
          client: clientInfo.copyWith(assignees: newAssignees)));
    } catch (e) {
      emit(state.error(e.toString()));
      return;
    }
  }

  Future<void> updateProfile(UserDto user) async {
    try {
      emit(state.loading());
      final newClient = state.client?.copyWith(
        name: user.name,
        avatar: user.avatar,
      );
      if (newClient != null) {
        await _clientRepository.updateClient(newClient);
      }
      await _userRepository.updateUser(user);
      emit(state.success(
          client: newClient, user: user, state: UpdateCitizenProfileSuccess()));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  @override
  CitizenProfileCubitState? fromJson(Map<String, dynamic> json) {
    return CitizenProfileCubitState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(CitizenProfileCubitState state) {
    return state.toJson();
  }
}
