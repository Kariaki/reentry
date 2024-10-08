import '../enum/account_type.dart';
import '../enum/emotions.dart';

class UserDto {
  final String userId;
  final String name;
  final AccountType accountType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? avatar;
  final String? about;
  final Emotions? emotion;

  UserDto({
    required this.userId,
    required this.name,
    required this.accountType,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    this.about,
    this.emotion,
  });

  // copyWith method
  UserDto copyWith({
    String? userId,
    String? name,
    AccountType? accountType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatar,
    String? about,
    Emotions? emotion,
  }) {
    return UserDto(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      about: about ?? this.about,
      emotion: emotion ?? this.emotion,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'accountType': accountType.toString().split('.').last,  // Assuming enum values should be converted to string
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatar': avatar,
      'about': about,
      'emotion': emotion?.toString().split('.').last,  // Assuming enum values should be converted to string
    };
  }

  // fromJson method
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'],
      name: json['name'],
      accountType: AccountType.values.firstWhere((e) => e.toString() == 'AccountType.' + json['accountType']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      avatar: json['avatar'],
      about: json['about'],
      emotion: json['emotion'] != null
          ? Emotions.values.firstWhere((e) => e.toString() == 'Emotions.' + json['emotion'])
          : null,
    );
  }
}
