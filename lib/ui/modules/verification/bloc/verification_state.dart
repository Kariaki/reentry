import 'package:reentry/data/model/user_dto.dart';
import '../../shared/cubit_state.dart';

class VerificationRequestCubitState {
  final CubitState? state;
  final List<UserDto> users;

  final List<UserDto> all;

  VerificationRequestCubitState({this.state, this.users = const [], this.all = const []});

  VerificationRequestCubitState copyWith(
      {CubitState? state, List<UserDto>? users, List<UserDto>? all}) =>
      VerificationRequestCubitState(
          state: state ?? this.state, users: users ?? this.users, all: all ?? this.all);

  VerificationRequestCubitState loading() =>
      copyWith(state: CubitStateLoading());

  VerificationRequestCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  VerificationRequestCubitState success({List<UserDto>? data,List<UserDto>? all,CubitState? state}) =>
      copyWith(users: data, state: state??CubitStateSuccess(),all: all);
}
class VerificationAccepted extends CubitState{}
class VerificationSubmitted extends CubitState{}
class VerificationRejected extends CubitState{}