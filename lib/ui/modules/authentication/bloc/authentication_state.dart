import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';

class AuthState {}

class AuthInitial extends AuthState {}
class LogoutSuccess extends AuthState {}

class AuthLoading extends AuthState {}
class LoginLoading extends AuthState {}

class OnboardingEntity extends AuthState {
  final String? name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String? id;
  final String? password;
  final List<String> services;
  final AccountType? accountType;
  final String? dob;
  final String? organization;
  final String? organizationAddress;final String? jobTitle;
  final String? supervisorsName;
  final String? supervisorsEmail;

  // Constructor
  OnboardingEntity({
    this.dob,
    this.name,
    this.address,
    this.phoneNumber,
    this.services = const [],
    this.id,
    required this.email,
    this.password,
    this.jobTitle,
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
    String? dob,
    String? organization,
    String? email,
    List<String>? services,
    String? organizationAddress,
    String? jobTitle,
    String? supervisorsName,
    String? supervisorsEmail,
  }) {
    return OnboardingEntity(
      name: name ?? this.name,
      address: address ?? this.address,
      dob: dob??this.dob,
      email: email ?? this.email,
      jobTitle: jobTitle??this.jobTitle,
      services: services??this.services,
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
        services: services,
        jobTitle: jobTitle,
        dob: dob,
        phoneNumber: phoneNumber,
        organization: organization,

        organizationAddress: organizationAddress,
        supervisorsEmail: supervisorsEmail,
        supervisorsName: supervisorsName,
        address: address);
  }
   @override
  String toString() {
    return 'OnboardingEntity(name: $name, email: $email, address: $address, phoneNumber: $phoneNumber, id: $id, password: $password, accountType: $accountType, dob: $dob, organization: $organization, organizationAddress: $organizationAddress, supervisorsName: $supervisorsName, supervisorsEmail: $supervisorsEmail)';
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
  UserDto? data;
  final String? authId;
  LoginSuccess(this.data,{this.authId});
}
class AuthSuccess extends AuthState {}
class PasswordResetSuccess extends AuthState {
  final bool resend;
  PasswordResetSuccess({this.resend=false});
}

class AuthenticationSuccess extends AuthState{
  String? userId;
   AuthenticationSuccess(this.userId);
}
class RegistrationSuccessFull extends AuthState {
  UserDto data;

  RegistrationSuccessFull(this.data);
}

//login success
//registration success
//
