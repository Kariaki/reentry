class ClientDto {
  final String id;
  final String name;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final String? droppedReason;
  final String? clientId;

  ClientDto({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.droppedReason,
    this.clientId,
  });

  // copyWith method
  ClientDto copyWith({
    String? id,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? droppedReason,
    String? clientId,
  }) {
    return ClientDto(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
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
      'userId': userId,
      'droppedReason': droppedReason,
      'clientId': clientId,
    };
  }

  // fromJson method
  factory ClientDto.fromJson(Map<String, dynamic> json) {
    return ClientDto(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
      droppedReason: json['droppedReason'],
      clientId: json['clientId'],
    );
  }
}
