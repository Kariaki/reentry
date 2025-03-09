import 'package:reentry/data/enum/account_type.dart';

class IncidenceDto {
  final DateTime date;
  final String title;
  final String description;
  final UsersInvolved victim;
  final UsersInvolved reported;
  final int responseCount;
  final String id;

  IncidenceDto copyWith({
    DateTime? date,
    String? title,
    String? description,
    UsersInvolved? victim,
    UsersInvolved? reported,
    int? responseCount,
    String? id,
  }) {
    return IncidenceDto(
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      victim: victim ?? this.victim,
      reported: reported ?? this.reported,
      responseCount: responseCount ?? this.responseCount,
      id: id ?? this.id,
    );
  }

  const IncidenceDto({
    required this.title,
    required this.description,
    required this.date,
    required this.id,
    this.responseCount = 0,
    required this.reported,
    required this.victim,
  });

  factory IncidenceDto.fromJson(Map<String, dynamic> json) {
    return IncidenceDto(
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      responseCount: json['responseCount'] as int? ?? 0,
      reported:
          UsersInvolved.fromJson(json['reported'] as Map<String, dynamic>),
      victim: UsersInvolved.fromJson(json['victim'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson(String id) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'responseCount': responseCount,
      'reported': reported.toJson(),
      'victim': victim.toJson(),
    };
  }
}

class UsersInvolved {
  final String userId;
  final String name;
  final AccountType account;

  const UsersInvolved({
    required this.name,
    required this.userId,
    required this.account,
  });

  factory UsersInvolved.fromJson(Map<String, dynamic> json) {
    return UsersInvolved(
      name: json['name'] as String,
      userId: json['userId'] as String,
      account: AccountType.values
          .firstWhere((e) => e.toString() == json['account'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'account': account.toString(),
    };
  }
}

class IncidenceResponse {
  final String text;
  final DateTime date;
  final String? id;

  const IncidenceResponse({
    required this.text,
    required this.date,
    this.id,
  });

  factory IncidenceResponse.fromJson(Map<String, dynamic> json) {
    return IncidenceResponse(
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date.toIso8601String(),
      'id': id,
    };
  }
}
