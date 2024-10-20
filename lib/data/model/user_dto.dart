import '../enum/account_type.dart';
import '../enum/emotions.dart';

class UserDto {
  final String? userId;
  final String name;
  final AccountType accountType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? avatar;
  final String? about;
  final String? email;
  final Emotions? emotion;
  final String? organization;
  final String? organizationAddress;
  final String? supervisorsName;
  final String? supervisorsEmail;
  final String? address;
  final String? phoneNumber;
  final String? password;

  UserDto({
    this.userId,
    required this.name,
    required this.accountType,
    this.createdAt,
    this.updatedAt,
    this.avatar,
    this.email,
    this.password,
    this.about,
    this.phoneNumber,
    this.address,
    this.supervisorsEmail,
    this.supervisorsName,
    this.organization,
    this.organizationAddress,
    this.emotion,
  });

  // copyWith method
  UserDto copyWith({
    String? userId,
    String? name,
    AccountType? accountType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? avatar,
    String? about,
    Emotions? emotion,
    String? organization,
    String? organizationAddress,
    String? supervisorsName,
    String? password,
    String? supervisorsEmail,
    String? address,
    String? phoneNumber,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      email: email??this.email,
      about: about ?? this.about,
      password: password??this.password,
      emotion: emotion ?? this.emotion,
      organization: organization ?? this.organization,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      supervisorsName: supervisorsName ?? this.supervisorsName,
      supervisorsEmail: supervisorsEmail ?? this.supervisorsEmail,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'accountType': accountType.toString().split('.').last, // Enum to string
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'avatar': avatar,
      'email': email,
      'about': about,
      'emotion': emotion?.toString().split('.').last, // Enum to string
      'organization': organization,
      'organizationAddress': organizationAddress,
      'supervisorsName': supervisorsName,
      'supervisorsEmail': supervisorsEmail,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  // fromJson method
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json['email'],
      userId: json['userId'],
      name: json['name'],
      accountType: AccountType.values.firstWhere(
              (e) => e.toString() == 'AccountType.' + json['accountType']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      avatar: json['avatar'],
      about: json['about'],
      emotion: json['emotion'] != null
          ? Emotions.values
          .firstWhere((e) => e.toString() == 'Emotions.' + json['emotion'])
          : null,
      organization: json['organization'],
      organizationAddress: json['organizationAddress'],
      supervisorsName: json['supervisorsName'],
      supervisorsEmail: json['supervisorsEmail'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

