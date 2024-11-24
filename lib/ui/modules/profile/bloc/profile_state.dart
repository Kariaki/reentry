import 'package:reentry/data/model/user_dto.dart';

class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileSuccess extends ProfileState {

}
class SettingsUpdateSuccess extends ProfileState {
  final UserDto user;
  SettingsUpdateSuccess(this.user);

}
class ProfileDataSuccess extends ProfileState{
  final UserDto data;
  ProfileDataSuccess(this.data);
}
