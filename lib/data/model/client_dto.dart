enum ClientStatus { pending, active, dropped,decline }

class ClientDto {
  final String id;
  final String name;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> assignees;
  final String? droppedReason;
  final String? clientId;
  final ClientStatus status;

  static const assigneesKey = 'assignees';
  static const statusKey = 'status';

  ClientDto({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignees = const [],
    this.droppedReason,
    this.clientId,
  });

  // copyWith method
  ClientDto copyWith({
    String? id,
    String? name,
    String? avatar,
    DateTime? createdAt,
    ClientStatus? status,
    DateTime? updatedAt,
    List<String>? assignees,
    String? droppedReason,
    String? clientId,
  }) {
    return ClientDto(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignees: assignees ?? this.assignees,
      droppedReason: droppedReason ?? this.droppedReason,
      clientId: clientId ?? this.clientId,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignees': assignees,
      'droppedReason': droppedReason,
      'status': status.index,
      'clientId': clientId,
    };
  }

  // fromJson method
  factory ClientDto.fromJson(Map<String, dynamic> json) {
    return ClientDto(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      status: ClientStatus.values[(json['status'] as int?) ?? 0],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      assignees: json['userId'],
      droppedReason: json['droppedReason'],
      clientId: json['clientId'],
    );
  }
}
