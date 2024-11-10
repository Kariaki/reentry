import 'package:reentry/data/model/user_dto.dart';

class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileSuccess extends ProfileState {

}
class ProfileDataSuccess extends ProfileState{
  final UserDto data;
  ProfileDataSuccess(this.data);
}
