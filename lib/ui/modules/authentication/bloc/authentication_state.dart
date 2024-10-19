import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OnboardingEntity extends AuthState {
  final String? name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String? id;
  final String? password;
  final AccountType? accountType;
  final String? organization;
  final String? organizationAddress;
  final String? supervisorsName;
  final String? supervisorsEmail;

  // Constructor
  OnboardingEntity({
    this.name,
    this.address,
    this.phoneNumber,
    this.id,
    required this.email,
    this.password,
    this.accountType,
    this.organization,
    this.organizationAddress,
    this.supervisorsName,
    this.supervisorsEmail,
  });

  // copyWith method
  OnboardingEntity copyWith({
    String? name,
    String? address,
    String? phoneNumber,
    String? password,
    AccountType? accountType,
    String? id,
    String? organization,
    String? email,
    String? organizationAddress,
    String? supervisorsName,
    String? supervisorsEmail,
  }) {
    return OnboardingEntity(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      accountType: accountType ?? this.accountType,
      organization: organization ?? this.organization,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      supervisorsName: supervisorsName ?? this.supervisorsName,
      supervisorsEmail: supervisorsEmail ?? this.supervisorsEmail,
    );
  }

  UserDto toUserDto() {
    return UserDto(
        userId: id,
        name: name!,
        accountType: accountType!,
        email: email,

        password: password,
        phoneNumber: phoneNumber,
        organization: organization,
        organizationAddress: organizationAddress,
        supervisorsEmail: supervisorsEmail,
        supervisorsName: supervisorsName,
        address: address);
  }
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class OAuthSuccess extends AuthState {
  UserDto? user;
  final String email;
  final String? name;
  final String? id;

  OAuthSuccess(this.user, {required this.email, this.name,this.id});
}

class LoginSuccess extends AuthState{
  UserDto data;
  LoginSuccess(this.data);
}
class AuthSuccess extends AuthState {}

class RegistrationSuccessFull extends AuthState {
  UserDto data;

  RegistrationSuccessFull(this.data);
}

//login success
//registration success
//
