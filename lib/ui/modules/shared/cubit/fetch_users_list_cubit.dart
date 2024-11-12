import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_user_list_state.dart';

class FetchUserListCubit extends Cubit<FetchUserListCubitState> {
  FetchUserListCubit() : super(FetchUserListCubitState.init());

  final _repo = UserRepository();

  Future<void> fetchUsers(List<String> ids) async {
    try {
      emit(state.loading());
      final result = await _repo.getUsersByIds(ids);
      emit(state.success(result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
