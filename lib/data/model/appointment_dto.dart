import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';

enum AppointmentStatus { all, upcoming, missed, done, canceled }

enum EventState { accepted, declined, pending }

class NewAppointmentDto {
  final String title;
  final String description;
  final String? location;
  final String? participantName;
  final String? participantAvatar;
  final String? participantId;
  final String creatorId;
  final int? timestamp;
  final EventState state;
  final List<String> orgs;
  final String? id;
  final AppointmentStatus status;
  final String? reasonForRejection;
  final DateTime date;
  final List<String> attendees;
  final String creatorName;
  final bool createdByMe;
  final String creatorAvatar;

  static const keyAttendees = 'attendees';
  static const keyStatus = 'status';
  static const keyState = 'state';
  static const keyCreatorId = 'creatorId';
  static const keyParticipantId = 'participantId';
  static const keyDate = 'timestamp';

  const NewAppointmentDto(
      {required this.title,
      required this.description,
      this.location,
      this.attendees = const [],
      this.participantAvatar,
      this.createdByMe = false,
      this.id,
      this.reasonForRejection,
      required this.date,
      this.participantName,
      required this.creatorAvatar,
      required this.creatorName,
      required this.status,
      this.orgs = const [],
      this.timestamp,
      this.participantId,
      required this.creatorId,
      required this.state});

  AppointmentUserDto? getParticipant() {
    if (participantId == null) {
      return null;
    }
    return AppointmentUserDto(
        userId: participantId ?? '',
        name: participantName ?? '',
        avatar: participantAvatar ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorAvatar': creatorAvatar,
      'timestamp': date.millisecondsSinceEpoch,
      'title': title,
      'description': description,
      'participantName': participantName,
      'participantAvatar': participantAvatar,
      'orgs': orgs,
      'participantId': participantId,
      'reasonForRejection': reasonForRejection,
      NewAppointmentDto.keyAttendees: [
        creatorId,
        if (participantId != null) participantId
      ],
      'state': state.name,
      'status': status.name,
      'location': location
    };
  }

  factory NewAppointmentDto.fromJson(Map<String, dynamic> json, String userId) {
    return NewAppointmentDto(
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String?,
      participantName: json['participantName'] as String?,
      orgs: json['orgs'] == null
          ? []
          : (json['orgs'] as List<dynamic>).map((e) => e.toString()).toList(),
      createdByMe: json['creatorId'] == userId,
      reasonForRejection: json['reasonForRejection'] as String?,
      participantAvatar: json['participantAvatar'] as String?,
      participantId: json['participantId'] as String?,
      creatorId: json['creatorId'] as String,
      timestamp: json['timestamp'] as int?,
      state: EventState.values.byName(json['state'] as String),
      attendees: (json[NewAppointmentDto.keyAttendees] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      id: json['id'] as String?,
      status: AppointmentStatus.values.byName(json['status'] as String),
      date: DateTime.parse(json['date'] as String),
      creatorName: json['creatorName'] as String,
      creatorAvatar: json['creatorAvatar'] as String,
    );
  }

  NewAppointmentDto copyWith({
    String? title,
    String? description,
    String? location,
    String? participantName,
    String? participantAvatar,
    String? participantId,
    String? creatorId,
    int? timestamp,
    EventState? state,
    String? id,
    AppointmentStatus? status,
    List<String>? orgs,
    String? reasonForRejection,
    DateTime? date,
    String? creatorName,
    String? creatorAvatar,
  }) {
    return NewAppointmentDto(
      title: title ?? this.title,
      description: description ?? this.description,
      orgs: orgs ?? this.orgs,
      location: location ?? this.location,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      participantId: participantId ?? this.participantId,
      creatorId: creatorId ?? this.creatorId,
      timestamp: timestamp ?? this.timestamp,
      reasonForRejection: reasonForRejection ?? this.reasonForRejection,
      state: state ?? this.state,
      id: id ?? this.id,
      status: status ?? this.status,
      date: date ?? this.date,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
    );
  }
}

class AppointmentDto {
  final String id;
  final String? note;
  final int time;
  final List<String> attendees;
  final int? bookedDay;
  final String? bookedTime;
  final AppointmentStatus status;
  static const keyAttendees = 'attendees';
  static const keyStatus = 'status';
  static const keyOrgs = 'orgs';

  AppointmentDto({
    required this.id,
    this.note,
    this.bookedDay,
    this.bookedTime,
    required this.status,
    required this.time,
    this.attendees = const [],
  });

  // copyWith method
  AppointmentDto copyWith({
    String? id,
    int? time,
    AppointmentStatus? status,
    String? note,
    int? bookedDay,
    String? bookedTime,
    List<String>? attendees,
  }) {
    return AppointmentDto(
      id: id ?? this.id,
      note: note ?? this.note,
      bookedDay: bookedDay ?? this.bookedDay,
      status: status ?? this.status,
      bookedTime: bookedTime ?? this.bookedTime,
      time: time ?? this.time,
      attendees: attendees ?? this.attendees,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'note': note,
      'status': status.name,
      'attendees': attendees,
      'bookedDay': bookedDay,
      'bookedTime': bookedTime
    };
  }

  // fromJson method
  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    final statusValue =
        (json['status'] as String?) ?? AppointmentStatus.upcoming.name;
    return AppointmentDto(
        id: json['id'],
        note: json['note'],
        status:
            AppointmentStatus.values.firstWhere((e) => e.name == statusValue),
        bookedTime: json['bookedTime'],
        bookedDay: json['bookedDay'],
        time: (json['time'] as int?) ?? 0,
        attendees: (json['attendees'] as List<dynamic>)
            .map((e) => e.toString())
            .toList());
  }
}

class AppointmentEntityDto {
  final String id;
  final String? note;
  final DateTime time;
  final String userId;
  final String name;
  final String accountType;
  final AppointmentStatus status;
  final int bookedDay;
  final String bookedTime;
  final String avatar;

  const AppointmentEntityDto(
      {required this.userId,
      required this.time,
      required this.bookedTime,
      required this.bookedDay,
      required this.accountType,
      required this.status,
      required this.name,
      required this.id,
      required this.note,
      required this.avatar});
}

class CreateAppointmentDto {}
