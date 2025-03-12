import 'package:http/http.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/data/model/client_dto.dart';
import '../../ui/modules/appointment/create_appointment_screen.dart';
import '../../ui/modules/messaging/entity/conversation_user_entity.dart';
import '../enum/account_type.dart';
import '../enum/emotions.dart';
import '../repository/verification/verification_request_dto.dart';

class FeelingDto {
  final Emotions emotion;
  final DateTime date;

  const FeelingDto({required this.date, required this.emotion});

  Map<String, dynamic> toJson() {
    return {'emotion': emotion.name, 'date': date.toIso8601String()};
  }

  factory FeelingDto.fromJson(Map<String, dynamic> json) {
    return FeelingDto(
        date: DateTime.parse(json['date']),
        emotion: Emotions.values.byName(json['emotion']));
  }
}

class IntakeForm {
  final String? whyAmIWhere;
  final String? whatDoIWantToContribute;
  final String? howDoIWantToGrow;
  final String? whereAmIGoing;
  final String? whatWouldIWantToExperienceInLife;
  final String? ifIAchievedAllMyLifeGoals;
  final String? whatIsMostImportantInMyLife;
  final String? myLifesMissionStatement;
  final String? myVisionStatement;
  final String? whereAmINow;
  final String? howDoIGetThere;

  IntakeForm({
    this.whyAmIWhere,
    this.whatDoIWantToContribute,
    this.howDoIWantToGrow,
    this.whereAmIGoing,
    this.whatWouldIWantToExperienceInLife,
    this.ifIAchievedAllMyLifeGoals,
    this.whatIsMostImportantInMyLife,
    this.myLifesMissionStatement,
    this.myVisionStatement,
    this.whereAmINow,
    this.howDoIGetThere,
  });

  factory IntakeForm.fromJson(Map<String, dynamic> json) {
    return IntakeForm(
      whyAmIWhere: json['whyAmIWhere'] ?? '',
      whatDoIWantToContribute: json['whatDoIWantToContribute'] ?? '',
      howDoIWantToGrow: json['howDoIWantToGrow'] ?? '',
      whereAmIGoing: json['whereAmIGoing'] ?? '',
      whatWouldIWantToExperienceInLife:
          json['whatWouldIWantToExperienceInLife'] ?? '',
      ifIAchievedAllMyLifeGoals: json['ifIAchievedAllMyLifeGoals'] ?? '',
      whatIsMostImportantInMyLife: json['whatIsMostImportantInMyLife'] ?? '',
      myLifesMissionStatement: json['myLifesMissionStatement'] ?? '',
      myVisionStatement: json['myVisionStatement'] ?? '',
      whereAmINow: json['whereAmINow'] ?? '',
      howDoIGetThere: json['howDoIGetThere'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'whyAmIWhere': whyAmIWhere,
      'whatDoIWantToContribute': whatDoIWantToContribute,
      'howDoIWantToGrow': howDoIWantToGrow,
      'whereAmIGoing': whereAmIGoing,
      'whatWouldIWantToExperienceInLife': whatWouldIWantToExperienceInLife,
      'ifIAchievedAllMyLifeGoals': ifIAchievedAllMyLifeGoals,
      'whatIsMostImportantInMyLife': whatIsMostImportantInMyLife,
      'myLifesMissionStatement': myLifesMissionStatement,
      'myVisionStatement': myVisionStatement,
      'whereAmINow': whereAmINow,
      'howDoIGetThere': howDoIGetThere,
    };
  }

  IntakeForm copyWith({
    String? whyAmIWhere,
    String? whatDoIWantToContribute,
    String? howDoIWantToGrow,
    String? whereAmIGoing,
    String? whatWouldIWantToExperienceInLife,
    String? ifIAchievedAllMyLifeGoals,
    String? whatIsMostImportantInMyLife,
    String? myLifesMissionStatement,
    String? myVisionStatement,
    String? whereAmINow,
    String? howDoIGetThere,
  }) {
    return IntakeForm(
      whyAmIWhere: whyAmIWhere ?? this.whyAmIWhere,
      whatDoIWantToContribute:
          whatDoIWantToContribute ?? this.whatDoIWantToContribute,
      howDoIWantToGrow: howDoIWantToGrow ?? this.howDoIWantToGrow,
      whereAmIGoing: whereAmIGoing ?? this.whereAmIGoing,
      whatWouldIWantToExperienceInLife: whatWouldIWantToExperienceInLife ??
          this.whatWouldIWantToExperienceInLife,
      ifIAchievedAllMyLifeGoals:
          ifIAchievedAllMyLifeGoals ?? this.ifIAchievedAllMyLifeGoals,
      whatIsMostImportantInMyLife:
          whatIsMostImportantInMyLife ?? this.whatIsMostImportantInMyLife,
      myLifesMissionStatement:
          myLifesMissionStatement ?? this.myLifesMissionStatement,
      myVisionStatement: myVisionStatement ?? this.myVisionStatement,
      whereAmINow: whereAmINow ?? this.whereAmINow,
      howDoIGetThere: howDoIGetThere ?? this.howDoIGetThere,
    );
  }
}

enum VerificationStatus{
  pending, rejected,
  verified,none
}
class UserDto {
  final String? userId;
  final String name;
  final AccountType accountType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final IntakeForm? intakeForm;
  final VerificationRequestDto? verification;
  final String? avatar;
  final List<String> organizations;
  final String? dob;
  final String? jobTitle;
  final List<String> services;
  final String? about;
  final List<String> assignee;
  final String? feelingsDate;
  final String? activityDate;
  final String? organization;
  final String? email;
  final String? userCode;
  final bool deleted;
  final Emotions? emotion;
  final String? organizationAddress;
  final String? pushNotificationToken;
  final String? reasonForAccountDeletion;
  final String? supervisorsName;
  final FeelingDto? feelingToday;
  final String? supervisorsEmail;
  final UserAvailability? availability;
  final String? address;
  final String? phoneNumber;
  final String? password;
  final UserSettings settings;
  final List<String> mentors;
  final List<FeelingDto> feelingTimeLine;
  final String? verificationStatus;
  final List<String> officers;

  ConversationUserEntity toConversationUserEntity() {
    return ConversationUserEntity(
        userId: userId ?? '', name: name, avatar: avatar);
  }

  static const keyUserId = 'userId';
  static const keyAccountType = 'accountType';
  static const keyDeleted = 'deleted';
  static const keyVerificationStatus = 'verificationStatus';

  ClientDto toClient() => ClientDto(
      id: userId ?? '',
      name: name,
      avatar: avatar ?? AppConstants.avatar,
      status: ClientStatus.active,
      createdAt: 0,
      updatedAt: 0);


  bool showFeeling(){

    final date = feelingsDate;
    if(date==null){
      return true;
    }
    final storedDateValue = DateTime.parse(date);
    final currentDateValue = DateTime.now();
    if (currentDateValue.difference(storedDateValue).inHours >= 8) {
      return true;
    }
    return false;
  }
  UserDto({
    this.userId,
    required this.name,
    required this.accountType,
    this.services = const [],
    this.availability,
    this.createdAt,
    this.verification,
    this.verificationStatus,
    this.intakeForm,
    this.activityDate,
    this.updatedAt,
    this.assignee = const [],
    this.feelingsDate,
    this.organizations = const [],
    this.pushNotificationToken,
    this.userCode,
    this.jobTitle,
    this.deleted = false,
    this.reasonForAccountDeletion,
    this.feelingTimeLine = const [],
    this.avatar,
    this.settings =
        const UserSettings(inAppNotification: false, pushNotification: false),
    this.email,
    this.dob,
    this.password,
    this.mentors = const [],
    this.officers = const [],
    this.about,
    this.phoneNumber,
    this.feelingToday,
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
    FeelingDto? feelingToday,
    String? feelingsDate,
    UserSettings? settings,
    String? email,
    String? avatar,
    VerificationRequestDto? verification,
    IntakeForm? intakeForm,
    String? verificationStatus,
    String? about,
    List<FeelingDto>? feelingTimeLine,
    List<String>? services,
    List<String>? assignee,
    Emotions? emotion,
    String? jobTitle,
    String? organization,
    String? organizationAddress,
    List<String>? organizations,
    String? activityDate,
    String? supervisorsName,
    String? dob,
    UserAvailability? availability,
    List<String>? mentors,
    String? pushNotificationToken,
    String? userCode,
    List<String>? officers,
    String? password,
    bool? deleted,
    String? reasonForAccountDeletion,
    String? supervisorsEmail,
    String? address,
    String? phoneNumber,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      officers: officers ?? this.officers,
      intakeForm: intakeForm ?? this.intakeForm,
      verification: verification??this.verification,
      feelingsDate: feelingsDate ?? this.feelingsDate,
      userCode: userCode ?? this.userCode,
      pushNotificationToken:
          pushNotificationToken ?? this.pushNotificationToken,
      name: name ?? this.name,
      verificationStatus: verificationStatus??this.verificationStatus,
      availability: availability ?? this.availability,
      mentors: mentors ?? this.mentors,
      accountType: accountType ?? this.accountType,
      dob: dob ?? this.dob,
      assignee: assignee ?? this.assignee,
      jobTitle: jobTitle ?? this.jobTitle,
      activityDate: activityDate ?? this.activityDate,
      createdAt: createdAt ?? this.createdAt,
      deleted: deleted ?? this.deleted,
      services: services ?? this.services,
      reasonForAccountDeletion:
          reasonForAccountDeletion ?? this.reasonForAccountDeletion,
      feelingTimeLine: feelingTimeLine ?? this.feelingTimeLine,
      settings: settings ?? this.settings,
      organizations: organizations ?? this.organizations,
      feelingToday: feelingToday ?? this.feelingToday,
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
      'services': services,
      'userCode': userCode,
      'feelingsDate': feelingsDate,
      'assignee': assignee,
      'verification':verification?.toJson(),
      'verificationStatus':verificationStatus??VerificationStatus.none.name,
      'activityDate': activityDate,
      'organizations': organizations,
      'intakeForm': intakeForm?.toJson(),
      'deleted': deleted,
      'accountType': accountType.name, // Enum to string
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'pushNotificationToken': pushNotificationToken,
      'availability': availability?.toJson(),
      'dob': dob,
      'feelingsToday': feelingToday?.toJson(),
      'job': jobTitle,
      'avatar': avatar ?? AppConstants.avatar,
      'feelingTimeLine': feelingTimeLine.map((e) => e.toJson()).toList(),
      'email': email,
      'about': about,
      'mentors': mentors,
      'officers': officers,
      'emotion': emotion?.name, // Enum to string
      'organization': organization,
      'organizationAddress': organizationAddress,
      'supervisorsName': supervisorsName,
      'supervisorsEmail': supervisorsEmail,
      'settings': settings.toJson(),
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  // fromJson method
  factory UserDto.fromJson(Map<String, dynamic> json) {
    final created =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    return UserDto(
      email: json['email'],
      organizations: json['organizations'] == null
          ? []
          : (json['organizations'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      assignee: json['assignee'] == null
          ? []
          : (json['assignee'] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
      pushNotificationToken: json['pushNotificationToken'],
      verificationStatus: json['verificationStatus'] as String?,
      verification: json['verification'] ==null?null:VerificationRequestDto.fromJson(json['verification']),
      activityDate: json['activityDate'] as String?,
      services: json['services']==null?[]:(json['services'] as List<dynamic>).map((e)=>e.toString()).toList(),
      userCode: created?.millisecondsSinceEpoch.toString(),
      feelingsDate: json['feelingsDate'] as String?,
      intakeForm: json['intakeForm'] == null
          ? null
          : IntakeForm.fromJson(json['intakeForm'] as Map<String, dynamic>),
      jobTitle: json['job'] as String?,
      feelingTimeLine: json['feelingTimeLine'] == null
          ? []
          : (json['feelingTimeLine'] as List<dynamic>).map((e) {
              return FeelingDto.fromJson(e as Map<String, dynamic>);
            }).toList(),
      feelingToday: json['feelingsToday'] == null
          ? null
          : FeelingDto.fromJson(json['feelingsToday']),
      userId: json['userId'],
      dob: json['dob'] as String?,
      // json['dob'] as String?,
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
      reasonForAccountDeletion: json['reasonForAccountDeletion'] as String?,
      deleted: (json['deleted'] as bool?) ?? false,
      emotion: json['emotion'] != null
          ? Emotions.values.firstWhere((e) => e.name == json['emotion'])
          : null,
      organization: json['organization'],
      organizationAddress: json['organizationAddress'],
      supervisorsName: json['supervisorsName'],

      settings: UserSettings.fromJson(json['settings']),
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

class UserSettings {
  final bool pushNotification;
  final bool inAppNotification;

  const UserSettings(
      {required this.inAppNotification, required this.pushNotification});

  UserSettings copyWith({bool? pushNotification, bool? inAppNotification}) =>
      UserSettings(
          inAppNotification: inAppNotification ?? this.inAppNotification,
          pushNotification: pushNotification ?? this.pushNotification);

  factory UserSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UserSettings(
          inAppNotification: false, pushNotification: false);
    }
    return UserSettings(
        inAppNotification: json['inAppNotification'],
        pushNotification: json['pushNotification']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotification': pushNotification,
      'inAppNotification': inAppNotification
    };
  }
}
