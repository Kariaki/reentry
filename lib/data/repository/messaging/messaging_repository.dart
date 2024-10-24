import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/exception/app_exceptions.dart';
import 'messaging_repository_interface.dart';

class MessageRepository implements MessagingRepositoryInterface {
  final conversationsCollection =
      FirebaseFirestore.instance.collection("conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  @override
  Future<ConversationDto?> createConversationFromMessage(
      MessageDto message) async {
    try {
      final doc = conversationsCollection.doc();
      final convo = ConversationDto(
          lastMessage: message.text,
          id: doc.id,
          members: [message.senderId, message.receiverId],
          timestamp: DateTime.now().millisecondsSinceEpoch);
      await doc.set(convo.toJson());
      return convo;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<ConversationDto>> fetchConversations(String userId) {
    final queryResult = conversationsCollection
        .where(ConversationDto.keyMembers, arrayContains: userId)
        .orderBy(ConversationDto.keyTimestamp, descending: true)
        .snapshots();
    return queryResult.map((event) {
      final result = event.docs.map((e) => ConversationDto.fromJson(e.data()));
      return result.toList();
    });
  }

  @override
  Stream<List<MessageDto>> fetchRoomMessages(
      String senderId, String receiverId) {
    final queryResult = conversationsCollection
        .where(MessageDto.keySenderId, isEqualTo: senderId)
        .where(MessageDto.keyReceiverId, isEqualTo: receiverId)
        .orderBy(ConversationDto.keyTimestamp, descending: true)
        .limitToLast(1000)
        .snapshots();
    return queryResult.map((event) {
      final result = event.docs.map((e) => MessageDto.fromJson(e.data()));
      return result.toList();
    });
  }

  @override
  Future<void> sendMessage(MessageDto body) async {
    try {
      if (body.conversationId == null) {
        final conversation = await createConversationFromMessage(body);
        if (conversation == null) {
          return;
        }
        final doc = messagesCollection.doc();
        final message =
            body.copyWith(conversationId: conversation.id, id: doc.id);
        await doc.set(message.toJson());
      }
    } catch (e) {
      throw BaseExceptions('Unable to send message');
    }
  }
}
