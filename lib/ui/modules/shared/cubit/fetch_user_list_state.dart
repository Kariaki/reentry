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

  bool get isLoading => state is CubitStateLoading;
  bool get isSuccess => state is CubitStateSuccess;
  bool get hasError => state is CubitStateError;
  String get errorMessage =>
      state is CubitStateError ? (state as CubitStateError).message : '';
}
