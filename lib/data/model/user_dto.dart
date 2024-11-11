import 'package:reentry/core/const/app_constants.dart';
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
  final String? dob;
  final String? about;
  final String? email;
  final Emotions? emotion;
  final String? organization;
  final String? organizationAddress;
  final String? pushNotificationToken;
  final String? supervisorsName;
  final String? supervisorsEmail;
  final UserAvailability? availability;
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
  static const keyAccountType = 'accountType';

  UserDto({
    this.userId,
    required this.name,
    required this.accountType,
    this.availability,
    this.createdAt,
    this.updatedAt,
    this.pushNotificationToken,
    this.avatar,
    this.email,
    this.dob
    ,
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
    String? dob,
    UserAvailability? availability,
    List<String>? mentors,
    String? pushNotificationToken,
    List<String>? officers,
    String? password,
    String? supervisorsEmail,
    String? address,
    String? phoneNumber,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      officers: officers ?? this.officers,
      pushNotificationToken:
          pushNotificationToken ?? this.pushNotificationToken,
      name: name ?? this.name,
      availability: availability ?? this.availability,
      mentors: mentors ?? this.mentors,
      accountType: accountType ?? this.accountType,
      dob: dob??this.dob,
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
      'pushNotificationToken': pushNotificationToken,
      'availability': availability?.toJson(),
      'dob':dob,
      'avatar': avatar ?? AppConstants.avatar,
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
      pushNotificationToken: json['pushNotificationToken'],
      userId: json['userId'],
      dob: json['dob'] as String?,
      availability: json['availability'] == null
          ? null
          : UserAvailability.fromJson(json['availability']),
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
      avatar: (json['avatar'] as String?) ?? AppConstants.avatar,
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

class UserAvailability {
  final List<int> days;
  final List<String> time;
  final String? date;

  const UserAvailability(
      {required this.time, required this.days, required this.date});

  Map<String, dynamic> toJson() {
    return {'days': days, 'time': time, 'date': date};
  }

  static UserAvailability fromJson(Map<String, dynamic> json) {
    final daysValue =
        (json['days'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [];
    final timeValue =
        (json['time'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            [];
    return UserAvailability(
        time: timeValue, days: daysValue, date: json['date'] as String?);
  }
}
