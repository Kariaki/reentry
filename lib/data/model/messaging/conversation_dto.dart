import 'package:reentry/data/model/messaging/message_dto.dart';

class ConversationDto {
  final String lastMessage;
  final int timestamp;
  final String id;
  final List<String> members;
  final String? name;
  final String? avatar;
  final String? lastMessageSenderId;
  final bool? seen;
  static const keyMembers = 'members';
  static const keyTimestamp = 'timestamp';

  const ConversationDto(
      {required this.lastMessage,
      required this.members,
      required this.id,
      this.name,
      this.lastMessageSenderId,
      this.seen,
      this.avatar,
      required this.timestamp});

  ConversationDto copyWithMessageDto(MessageDto message) {
    return ConversationDto(
        lastMessage: message.text,
        members: members,
        lastMessageSenderId: message.senderId,
        id: id,
        timestamp: message.timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  ConversationDto read({bool read=true}) {
    return ConversationDto(
        lastMessage: lastMessage,
        members: members,
        id: id,
        timestamp: timestamp,
        lastMessageSenderId: lastMessageSenderId,
        seen: read,
        name: name,
        avatar: avatar);
  }

  Map<String, dynamic> toJson() => {
        'lastMessage': lastMessage,
        'timestamp': timestamp,
        'seen': seen,
        'lastMessageSenderId': lastMessageSenderId,
        'id': id,
        'members': members,
      };

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
        lastMessage: json['lastMessage'],
        lastMessageSenderId: json['lastMessageSenderId'] as String?,
        id: json['id'],
        seen: json['seen'] as bool?,
        members: (json[keyMembers] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        timestamp: json[keyTimestamp]);
  }
}
