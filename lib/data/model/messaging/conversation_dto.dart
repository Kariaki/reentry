import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';

class ConversationUser {
  final String userId;
  final String name;
  final String avatar;
  final AccountType accountType;

  static ConversationUser fromJson(Map<String, dynamic> json) {
    return ConversationUser(
        name: json['name'],
        userId: json['userId'],
        avatar: json['avatar'],
        accountType: AccountType.values
                .where((e) => e.name == json['account_type'])
                .firstOrNull ??
            AccountType.citizen);
  }

  const ConversationUser(
      {required this.name,
      required this.userId,
      required this.avatar,
      required this.accountType});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'account_type': accountType.name,
      'name': name,
      'avatar': avatar ?? AppConstants.avatar
    };
  }
}

class ConversationDto {
  final String lastMessage;
  final int timestamp;
  final String id;
  final List<String> members;
  final String? name;
  final String? avatar;
  final List<ConversationUser> membersInfo;
  final ConversationUser? conversationUser;
  final String? lastMessageSenderId;
  final bool? seen;
  static const keyMembers = 'members';
  static const keyTimestamp = 'timestamp';

  const ConversationDto(
      {required this.lastMessage,
      required this.members,
      this.membersInfo = const [],
      required this.id,
      this.name,
      this.conversationUser,
      this.lastMessageSenderId,
      this.seen,
      this.avatar,
      required this.timestamp});

  ConversationDto copyWithMessageDto(MessageDto message) {
    return ConversationDto(
        lastMessage: message.text,
        members: members,
        conversationUser: conversationUser,
        lastMessageSenderId: message.senderId,
        membersInfo: membersInfo,
        id: id,
        timestamp: message.timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  ConversationDto copyWithConversationUser(ConversationUser conversationUser) {
    return ConversationDto(
        lastMessage: lastMessage,
        members: members,
        conversationUser: conversationUser,
        seen: seen,
        lastMessageSenderId: lastMessageSenderId,
        membersInfo: membersInfo,
        id: id,
        timestamp: timestamp);
  }

  ConversationDto read({bool read = true}) {
    return ConversationDto(
        lastMessage: lastMessage,
        conversationUser: conversationUser,
        membersInfo: membersInfo,
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
        'membersInfo': membersInfo.map((e) => e.toJson()).toList(),
        'seen': seen,
        'lastMessageSenderId': lastMessageSenderId,
        'id': id,
        'members': members,
      };

  factory ConversationDto.fromJson(Map<String, dynamic> json, String userId) {
    final membersInfo = (json['membersInfo'] as List<dynamic>)
        .map((e) => ConversationUser.fromJson(e))
        .toList();
    return ConversationDto(
        lastMessage: json['lastMessage'],
        lastMessageSenderId: json['lastMessageSenderId'] as String?,
        id: json['id'],
        seen: json['seen'] as bool?,
        conversationUser: membersInfo.firstWhere((e) => e.userId != userId),
        membersInfo: membersInfo,
        members: (json[keyMembers] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        timestamp: json[keyTimestamp]);
  }
}
