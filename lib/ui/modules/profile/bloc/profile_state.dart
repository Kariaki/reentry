import 'package:reentry/data/model/user_dto.dart';

class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileSuccess extends ProfileState {

}
class IntakeFormSuccess extends ProfileState {
  final UserDto user;
  IntakeFormSuccess(this.user);

}
class SettingsUpdateSuccess extends ProfileState {
  final UserDto user;
  SettingsUpdateSuccess(this.user);

}
class DeleteAccountSuccess extends ProfileState{}
class ProfileDataSuccess extends ProfileState{
  final UserDto data;
  ProfileDataSuccess(this.data);
}
