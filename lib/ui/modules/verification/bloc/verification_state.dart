import 'package:reentry/data/model/user_dto.dart';
import '../../shared/cubit_state.dart';

class VerificationRequestCubitState {
  final CubitState? state;
  final List<UserDto> users;

  VerificationRequestCubitState({this.state, this.users = const []});

  VerificationRequestCubitState copyWith(
      {CubitState? state, List<UserDto>? users}) =>
      VerificationRequestCubitState(
          state: state ?? this.state, users: users ?? this.users);

  VerificationRequestCubitState loading() =>
      copyWith(state: CubitStateLoading());

  VerificationRequestCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  VerificationRequestCubitState success({List<UserDto>? data,CubitState? state}) =>
      copyWith(users: data, state: state??CubitStateSuccess());
}
class VerificationAccepted extends CubitState{}
class VerificationSubmitted extends CubitState{}
class VerificationRejected extends CubitState{}