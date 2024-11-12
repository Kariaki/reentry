import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class FetchUserListCubitState {
  final List<UserDto> data;
  final CubitState state;

  const FetchUserListCubitState(this.data, this.state);

  static FetchUserListCubitState init() =>
      FetchUserListCubitState([], CubitState());

  FetchUserListCubitState loading() =>
      FetchUserListCubitState(data, CubitStateLoading());

  FetchUserListCubitState error(String error) =>
      FetchUserListCubitState(data, CubitStateError(error));

  FetchUserListCubitState success(List<UserDto> data) =>
      FetchUserListCubitState(data, CubitStateSuccess());
}
