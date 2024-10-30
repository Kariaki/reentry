import 'package:reentry/ui/modules/appointment/appointment_calender_screen.dart';

import '../../ui/modules/messaging/entity/conversation_user_entity.dart';
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
  final List<String> mentors;
  final List<String> officers;

  ConversationUserEntity toConversationUserEntity() {
    return ConversationUserEntity(
        userId: userId ?? '', name: name, avatar: avatar);
  }

  static const keyUserId = 'userId';

  UserDto({
    this.userId,
    required this.name,
    required this.accountType,
    this.createdAt,
    this.updatedAt,
    this.avatar,
    this.email,
    this.password,
    this.mentors = const [],
    this.officers = const [],
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
    List<String>? mentors,
    List<String>? officers,
    String? password,
    String? supervisorsEmail,
    String? address,
    String? phoneNumber,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      officers: officers ?? this.officers,
      name: name ?? this.name,
      mentors: mentors ?? this.mentors,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      about: about ?? this.about,
      password: password ?? this.password,
      emotion: emotion ?? this.emotion,
      organization: organization ?? this.organization,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      supervisorsName: supervisorsName ?? this.supervisorsName,
      supervisorsEmail: supervisorsEmail ?? this.supervisorsEmail,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  AppointmentUserDto toAppointmentUserDto() {
    return AppointmentUserDto(
        userId: userId!, name: name, avatar: avatar ?? '');
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'accountType': accountType.name, // Enum to string
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'avatar': avatar ??
          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
      'email': email,
      'about': about,
      'mentors': mentors,
      'officers': officers,
      'emotion': emotion?.name, // Enum to string
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
      mentors: json['mentors'] == null
          ? []
          : (json['mentors'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      officers: json['officers'] == null
          ? []
          : (json['officers'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      name: json['name'],
      accountType:
          AccountType.values.firstWhere((e) => e.name == json['accountType']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      avatar: json['avatar'],
      about: json['about'],
      emotion: json['emotion'] != null
          ? Emotions.values.firstWhere((e) => e.name == json['emotion'])
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
