import 'package:flutter/cupertino.dart';
import 'package:reentry/data/enum/account_type.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class OnboardingEntity extends AuthState {
  final String? name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String password;
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
    required this.email,
    required this.password,
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
    String? organization,
    String? email,
    String? organizationAddress,
    String? supervisorsName,
    String? supervisorsEmail,
  }) {
    return OnboardingEntity(
      name: name ?? this.name,
      address: address ?? this.address,
      email: email??this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      accountType: accountType ?? this.accountType,
      organization: organization ?? this.organization,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      supervisorsName: supervisorsName ?? this.supervisorsName,
      supervisorsEmail: supervisorsEmail ?? this.supervisorsEmail,
    );
  }
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthSuccess extends AuthState {}
class RegistrationSuccessFull extends AuthState {}

//login success
//registration success
//
