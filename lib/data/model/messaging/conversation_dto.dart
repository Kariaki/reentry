import 'package:reentry/data/model/messaging/message_dto.dart';

class ConversationDto {
  final String lastMessage;
  final int timestamp;
  final String id;
  final List<String> members;
  final String? name;
  final String? avatar;
  static const keyMembers = 'members';
  static const keyTimestamp = 'timestamp';

  const ConversationDto(
      {required this.lastMessage,
      required this.members,
      required this.id,
      this.name,
      this.avatar,
      required this.timestamp});

  ConversationDto copyWithMessageDto(MessageDto message) {
    return ConversationDto(
        lastMessage: message.text,
        members: members,
        id: id,
        timestamp: message.timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() => {
        'lastMessage': lastMessage,
        'timestamp': timestamp,
        'id': id,
        'members': members,
      };

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
        lastMessage: json['lastMessage'],
        id: json['id'],
        members: (json[keyMembers] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        timestamp: json[keyTimestamp]);
  }
}
