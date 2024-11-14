import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';

import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../../data/repository/clients/client_repository.dart';

class AdminUsersCubit extends Cubit<CubitState> {
  AdminUsersCubit() : super(CubitState());

  final _repo = AdminRepository();

  Future<void> fetchCitizens() => _fetchUserByType(AccountType.citizen);

  Future<void> fetchNonCitizens() async {
    try {
      //use this to fetch all non citizens
      emit(CubitStateLoading());
      final result = await _repo.getNonCitizens();
      emit(CubitDataStateSuccess<List<UserDto>>(result));
    } catch (e) {
      emit(CubitStateError(e.toString()));
    }
  }

  // Future<void> fetchMentors() => _fetchUserByType(AccountType.mentor);

  List<UserDto>? _mentors;
  List<UserDto>? _officers;

  Future<void> fetchMentors() async {
    try {
      emit(CubitStateLoading());
      final result = await _repo.getUsers(AccountType.mentor);
      _mentors = result;
      emit(CubitDataStateSuccess<List<UserDto>>(result));
    } catch (e) {
      emit(CubitStateError(e.toString()));
    }
  }

  UserDto? getMentorById(String mentorId) {
    try {
      return _mentors?.firstWhere((mentor) => mentor.userId == mentorId);
    } catch (e) {
      return null;
    }
  }

  // Future<void> fetchOfficers() => _fetchUserByType(AccountType.officer);

  Future<void> fetchOfficers() async {
    try {
      emit(CubitStateLoading());
      final result = await _repo.getUsers(AccountType.officer);
      _mentors = result;
      emit(CubitDataStateSuccess<List<UserDto>>(result));
    } catch (e) {
      emit(CubitStateError(e.toString()));
    }
  }

  UserDto? getOfficerById(String officerId) {
    try {
      return _officers?.firstWhere((officer) => officer.userId == officerId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _fetchUserByType(AccountType type) async {
    try {
      emit(CubitStateLoading());
      final result = await _repo.getUsers(type);
      print(
          "Fetched ${type.name} list: ${result.map((user) => user.toJson()).toList()}");
      emit(CubitDataStateSuccess<List<UserDto>>(result));
    } catch (e) {
      emit(CubitStateError(e.toString()));
    }
  }
}

//use to fetch all citizen
class AdminCitizenCubit extends Cubit<CubitState> {
  final _repo = ClientRepository();

  AdminCitizenCubit() : super(CubitState());

  Future<void> fetchCitizens() async {
    try {
      emit(CubitStateLoading());
      final result = await _repo.getAllClients();
      emit(CubitDataStateSuccess<List<ClientDto>>(result));
    } catch (e) {
      emit(CubitStateError(e.toString()));
    }
  }
}
