import 'package:reentry/data/model/messaging/conversation_dto.dart';

class MessageDto {
  final String? id;
  final String senderId;
  final String receiverId;
  final String? conversationId;
  final String text;
  final int? timestamp;
  static const keyConversationId = 'conversationId';
  static const keySenderId = 'senderId';
  static const keyReceiverId = 'receiverId';

  const MessageDto(
      {this.id,
      required this.senderId,
      required this.receiverId,
      this.conversationId,
      required this.text,
      this.timestamp});

  MessageDto copyWith(
          {String? id,
          String? receiverId,
          String? conversationId,
          String? senderId}) =>
      MessageDto(
          senderId: senderId ?? this.senderId,
          receiverId: receiverId ?? this.receiverId,
          conversationId: conversationId ?? this.conversationId,
          text: text,
          id: id ?? this.id);

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      id: json['id'],
      timestamp: json[ConversationDto.keyTimestamp],
      conversationId: json[MessageDto.keyConversationId],
      text: json['text']);

  Map<String, dynamic> toJson() => {
    ConversationDto.keyTimestamp: DateTime.now().toIso8601String(),
        'senderId': senderId,
        'receiverId': receiverId,
        'id': id,
        MessageDto.keyConversationId: conversationId,
        'text': text
      };
}
