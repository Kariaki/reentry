class GoalDto {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime endDate;

  GoalDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.endDate,
  });

  // copyWith method
  GoalDto copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? createdAt,
    DateTime? endDate,
  }) {
    return GoalDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      endDate: endDate ?? this.endDate,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  // fromJson method
  factory GoalDto.fromJson(Map<String, dynamic> json) {
    return GoalDto(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
