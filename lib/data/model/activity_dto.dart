enum Frequency { daily, weekly }

class ActivityDto {
  final String id;
  final Frequency frequency;
  final List<int> timeLine;
  final String title;
  final int dayStreak;

  const ActivityDto({
    required this.frequency,
    required this.title,
    this.dayStreak=0,
    required this.timeLine,
    this.id = '',
  });

  // fromJson method
  factory ActivityDto.fromJson(Map<String, dynamic> json) {
    return ActivityDto(
      id: json['id'] ?? '',
      dayStreak: json['dayStreak'],
      frequency: Frequency.values.byName(json['frequency']),
      timeLine: List<int>.from(json['timeLine']),
      title: json['title'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frequency': frequency.name,
      'dayStreak':dayStreak,
      'timeLine': timeLine,
      'title': title,
    };
  }

  ActivityDto copyWith({
    String? id,
    Frequency? frequency,
    List<int>? days,
    int? dayStreak,
    String? title,
  }) {
    return ActivityDto(
      id: id ?? this.id,
      dayStreak: dayStreak??this.dayStreak,
      frequency: frequency ?? this.frequency,
      timeLine: days ?? this.timeLine,
      title: title ?? this.title,
    );
  }
}
