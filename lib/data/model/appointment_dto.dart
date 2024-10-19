class AppointmentDto {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? note;
  final DateTime date;
  final String creatorId;
  final String userId;

  AppointmentDto({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.note,
    required this.date,
    required this.creatorId,
    required this.userId,
  });

  // copyWith method
  AppointmentDto copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? note,
    DateTime? date,
    String? creatorId,
    String? userId,
  }) {
    return AppointmentDto(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      note: note ?? this.note,
      date: date ?? this.date,
      creatorId: creatorId ?? this.creatorId,
      userId: userId ?? this.userId,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'note': note,
      'date': date.toIso8601String(),
      'creatorId': creatorId,
      'userId': userId,
    };
  }

  // fromJson method
  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentDto(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      note: json['note'],
      date: DateTime.parse(json['date']),
      creatorId: json['creatorId'],
      userId: json['userId'],
    );
  }
}

class CreateAppointmentDto{}