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
  Stream<List<MessageDto>> fetchRoomMessages(String conversationId) {
    final queryResult = messagesCollection
        .where(MessageDto.keyConversationId, isEqualTo: conversationId)
        .orderBy(ConversationDto.keyTimestamp, descending: true)
        .limitToLast(1000)
        .snapshots();
    return queryResult.map((event) {
      final result = event.docs.map((e) => MessageDto.fromJson(e.data()));
      return result.toList();
    });
  }
  Future<ConversationDto?> _getConversation(
      MessageDto message) async {
    try {

      final  doc = conversationsCollection.doc(message.conversationId);
      final currentConversationDoc = await doc.get();
      if(currentConversationDoc.exists){
        final data = ConversationDto.fromJson(currentConversationDoc.data()!).copyWithMessageDto(message);
        await doc.set(data.toJson()); //update already existing and return null
        return null;
      }
      final convo = ConversationDto(
          lastMessage: message.text,
          id: doc.id,
          members: [message.senderId, message.receiverId],
          timestamp: DateTime.now().millisecondsSinceEpoch);
      await doc.set(convo.toJson()); //create a new one and return the ID
      return convo;
    } catch (e) {
      return null;
    }
  }
  @override
  Future<String?> sendMessage(MessageDto body) async {
    try {
      final convo = await _getConversation(body);
      final doc = messagesCollection.doc();
      final payload = body.copyWith(conversationId: convo?.id,id: doc.id);
      await doc.set(payload.toJson());
      return convo?.id;
    } catch (e) {
      throw BaseExceptions('Unable to send message');
    }
  }
}
