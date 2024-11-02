enum AppointmentStatus{
  upcoming,missed,done
}
class AppointmentDto {
  final String id;
  final String? note;
  final int time;
  final List<String> attendees;

  static const keyAttendees = 'attendees';

  AppointmentDto({
    required this.id,
    this.note,
    required this.time,
    this.attendees = const [],
  });

  // copyWith method
  AppointmentDto copyWith({
    String? id,
    int? time,
    String? note,
    List<String>? attendees,
  }) {
    return AppointmentDto(
      id: id ?? this.id,
      note: note ?? this.note,
      time: time ?? this.time,
      attendees: attendees ?? this.attendees,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'id': id, 'time': time, 'note': note, 'attendees': attendees};
  }

  // fromJson method
  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentDto(
        id: json['id'],
        note: json['note'],
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
  final String avatar;

  const AppointmentEntityDto(
      {required this.userId,
      required this.time,
        required this.accountType,
      required this.name,
      required this.id,
      required this.note,
      required this.avatar});
}

class CreateAppointmentDto {}
