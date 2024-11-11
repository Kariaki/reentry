import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/admin/admin_repository.dart';

import 'package:reentry/ui/modules/shared/cubit_state.dart';

class AdminUsersCubit extends Cubit<CubitState>{
  AdminUsersCubit():super(CubitState());

  final _repo = AdminRepository();
  Future<void> fetchCitizens() => _fetchUserByType(AccountType.citizen);
  Future<void> fetchMentors() => _fetchUserByType(AccountType.mentor);
  Future<void> fetchOfficers() => _fetchUserByType(AccountType.officer);

  Future<void> _fetchUserByType(AccountType type)async{
    try{
      emit(CubitStateLoading());
      final result = await _repo.getUsers(type);
      emit(CubitDataStateSuccess<List<UserDto>>(result));
    }catch(e){
      emit(CubitStateError(e.toString()));
    }
  }

}