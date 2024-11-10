import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/messaging/conversation_dto.dart';

class ReceiverInfo {
  final String name;
  final String avatar;
  final AccountType accountType;

  const ReceiverInfo(
      {required this.name, required this.avatar, required this.accountType});
}

class MessageDto {
  final String? id;
  final String senderId;
  final String receiverId;
  final String? conversationId;
  final String text;
  final ReceiverInfo? receiverInfo;
  final int? timestamp;
  static const keyConversationId = 'conversationId';
  static const keySenderId = 'senderId';
  static const keyReceiverId = 'receiverId';
  static const members = 'members';

  const MessageDto(
      {this.id,
      required this.senderId,
      required this.receiverInfo,
      required this.receiverId,
      this.conversationId,
      required this.text,
      this.timestamp});

  ConversationUser toConversationUser() {
    return ConversationUser(
        accountType: receiverInfo?.accountType ?? AccountType.citizen,
        name: receiverInfo?.name ?? '',
        userId: receiverId,
        avatar: receiverInfo?.avatar ?? '');
  }

  MessageDto copyWith(
          {String? id,
          String? receiverId,
          String? conversationId,
          ReceiverInfo? receiverInfo,
          String? senderId}) =>
      MessageDto(
          senderId: senderId ?? this.senderId,
          receiverId: receiverId ?? this.receiverId,
          receiverInfo: receiverInfo ?? this.receiverInfo,
          conversationId: conversationId ?? this.conversationId,
          text: text,
          id: id ?? this.id);

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      receiverInfo: null,
      id: json['id'],
      timestamp: json[ConversationDto.keyTimestamp],
      conversationId: json[MessageDto.keyConversationId],
      text: json['text']);

  Map<String, dynamic> toJson() => {
        ConversationDto.keyTimestamp: DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId,
        'receiverId': receiverId,
        'members': [receiverId, senderId],
        'id': id,
        MessageDto.keyConversationId: conversationId,
        'text': text
      };
}
