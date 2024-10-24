import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';

abstract class MessagingRepositoryInterface {
  Future<void> sendMessage(MessageDto body);

  Stream<List<MessageDto>> fetchRoomMessages(
      String senderId, String receiverId);

  Stream<List<ConversationDto>> fetchConversations(String userId);

  Future<ConversationDto?> createConversationFromMessage(MessageDto message);
}
