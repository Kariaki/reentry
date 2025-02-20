class GoalDto {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final String? duration;
  final DateTime endDate;
  final int progress;
  static const durations = [
    'Weekly',
    'Bi-Weekly',
    'Monthly',
    'Quarterly',
    '6 months',
    "1 year",
    "5 years",
    "10 years"
  ];

  static const keyProgress = 'progress';
  static const keyCreatedAt = 'createdAt';
  static const keyEndDate = 'endDate';
  static const startDate = 'createdAt';

  GoalDto({
    required this.id,
    required this.userId,
    this.progress = 0,
    required this.title,
    required this.duration,
    required this.createdAt,
    required this.endDate,
  });

  // copyWith method
  GoalDto copyWith({
    String? id,
    int? progress,
    String? userId,
    String? title,
    String? duration,
    DateTime? createdAt,
    DateTime? endDate,
  }) {
    return GoalDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
      title: title ?? this.title,
      duration: duration??this.duration,
      createdAt: createdAt ?? this.createdAt,
      endDate: endDate ?? this.endDate,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'progress': progress,
      'userId': userId,
      'duration':duration,
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  // fromJson method
  factory GoalDto.fromJson(Map<String, dynamic> json) {
    return GoalDto(
      id: json['id'],
      progress: json['progress'],
      duration: json['duration'],
      userId: json['userId'],
      title: json['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
    );
  }
}
