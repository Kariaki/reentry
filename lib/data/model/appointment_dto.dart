enum AppointmentStatus { upcoming, missed, done,canceled }

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
        time: json['time'],
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
