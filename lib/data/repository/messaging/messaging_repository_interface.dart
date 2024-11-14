import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';

abstract class MessagingRepositoryInterface {
  Future<void> sendMessage(MessageDto body);

  Stream<List<MessageDto>> fetchRoomMessages(
      String conversationId);

  Stream<List<ConversationDto>> fetchConversations(String userId);

  Future<void> readConversation(String id);
  Future<ConversationDto?> createConversationFromMessage(MessageDto message);
  Stream<List<MessageDto>> onNewMessage(String userId);
}
