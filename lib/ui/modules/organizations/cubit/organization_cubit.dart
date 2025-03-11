import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/util/util.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/org/organization_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class OrganizationCubit extends Cubit<OrganizationCubitState> {
  OrganizationCubit() : super(OrganizationCubitState(state: CubitState()));

  final _repo = OrganizationRepository();
  final userRepo = UserRepository();

  Future<void> joinOrganization(String id) async {
    UserDto? user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    try {
      emit(state.loading());
      user = user.copyWith(
          organizations: user.organizations.contains(id)
              ? user.organizations
              : [...user.organizations, id]);
      await _repo.joinOrganization(id, user.userId ?? '');
      await PersistentStorage.cacheUserInfo(user);
      fetchOrganizations(currentUser: user);
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> fetchOrganizations({UserDto? currentUser}) async {
    UserDto? user = await PersistentStorage.getCurrentUser();
    user = currentUser ?? user;
    if (user == null) {
      return;
    }
    if (user.accountType == AccountType.reentry_orgs ||
        user.accountType == AccountType.citizen) {
      return;
    }
    try {
      emit(state.loading());

      List<UserDto> result = [];
      if (user.accountType == AccountType.admin) {
        result = await _repo.getAllOrganizations();
        for (var i in result) {
          log('${i.toJson()}');
        }
      } else {
        result = await _repo.getOrganizationsOfCareTeam(user);
      }
      emit(state.success(data: result, foundOrganization: null, all: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> findOrganizationByCode(String code) async {
    try {
      emit(state.loading());
      final result = await _repo.findOrganizationByCode(code);
      if (result == null) {
        emit(state.error("No organization found"));
        return;
      }
      if (state.data.where((e) => e.userId == result.userId).isNotEmpty) {
        emit(state.error("Already joined this organization"));
        return;
      }
      final careTeams =
          await _repo.getCareTeamByOrganization(result.userId ?? '');
      const citizens = 0;
      emit(state.success(
          foundOrganization: FoundOrganization(
              careTeam: careTeams.length, citizens: citizens, data: result)));
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace);
      emit(state.error(e.toString()));
    }
  }

  void selectOrganization(UserDto selected) {
   // UserRepository().updateUser(selected.copyWith(services: AppConstants.careTeamServices.sublist(2)));
    emit(state.success(selectedOrganization: selected));
  }

  void search(String value) {
    emit(state.success(
        data: state.all.where((e) {
      return e.name.toLowerCase().contains(value) ||
          (e.organization?.toLowerCase().contains(value) ?? false) ||
          e.createdAt?.millisecondsSinceEpoch.toString() == value;
    }).toList()));
  }
}

class OrganizationMembersCubit extends Cubit<OrganizationMembersCubitState> {
  OrganizationMembersCubit() : super(const OrganizationMembersCubitState());

  final _repo = OrganizationRepository();
  final _userRepo = UserRepository();

  Future<void> fetchUsersByOrganization(String orgId) async {
    emit(state.loading());
    try {
      final result = await _repo.getUsersByOrganization(orgId);
      print('kebilate -> org success');
      emit(state.success(result));
    } catch (e) {
      print('kebilate -> org error -> ${e.toString()}');
      emit(state.error(e.toString()));
    }
  }

  void clear() {
    emit(state.success([]));
  }

  Future<void> addToOrg(UserDto user, String orgId) async {
    try {
      emit(state.loading());
      await _userRepo.updateUser(user);
      final data = [...state.data, user];
      emit(state.success(data));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> deleteAmount(UserDto user, String orgId) async {
    try {
      emit(state.loading());
      final newUser = user.copyWith(
          organizations: user.organizations.where((e) => e != orgId).toList());
      await _userRepo.updateUser(newUser);
      final data = state.data.where((e) => e.userId != user.userId).toList();
      emit(state.success(data));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
