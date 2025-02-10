import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/exception/app_exceptions.dart';
import 'messaging_repository_interface.dart';

class MessageRepository implements MessagingRepositoryInterface {
  final conversationsCollection =
      FirebaseFirestore.instance.collection("conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  Future<void> deleteConversation(List<String> ids)async{

    // final queryResult = conversationsCollection
    //     .where(ConversationDto.keyMembers,arrayContains: ids[0]).get();
  }
  @override
  Future<ConversationDto?> createConversationFromMessage(
      MessageDto message) async {
    try {
      final doc = conversationsCollection.doc();
      final currentUser = await PersistentStorage.getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      final membersInfo = [
        message.toConversationUser(),
        ConversationUser(
            name: currentUser.name,
            accountType: currentUser.accountType,
            userId: currentUser.userId ?? '',
            avatar: currentUser.avatar ?? AppConstants.avatar)
      ];
      final convo = ConversationDto(
          lastMessage: message.text,
          membersInfo: membersInfo,
          seen: false,
          lastMessageSenderId: message.senderId,
          id: doc.id,
          members: [message.senderId, message.receiverId],
          timestamp: DateTime.now().millisecondsSinceEpoch);
      await doc.set(convo.toJson());
      return convo;
    } catch (e) {
      return null;
    }
  }

  Future<void> _sendMessagePushNotification(MessageDto message)async{
    try {
      final receiver = await AuthRepository().findUserById(message.receiverId);
      final token = receiver?.pushNotificationToken;
      if (token != null) {
        //send push notification to user;
      }
    }catch(e){

    }
  }
  @override
  Stream<List<ConversationDto>> fetchConversations(String userId) {
    final queryResult = conversationsCollection
        .where(ConversationDto.keyMembers, arrayContains: userId)
        .orderBy(ConversationDto.keyTimestamp, descending: true)
        .snapshots();
    return queryResult.map((event) {
      final result =
          event.docs.map((e) => ConversationDto.fromJson(e.data(), userId));

      return result.toList();
    });
  }

  @override
  Future<void> readConversation(String id) async {
    final doc = conversationsCollection.doc(id);
    final currentConversationDoc = await doc.get();
    final currentUser = await PersistentStorage.getCurrentUser();
    if (currentConversationDoc.exists) {
      ConversationDto data = ConversationDto.fromJson(
          currentConversationDoc.data()!, currentUser?.userId ?? '');
      if (data.lastMessageSenderId != currentUser?.userId) {
        data = data.read();
        doc.set(data.toJson());
      }
    }
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

  Future<ConversationDto?> _getConversation(MessageDto message) async {
    try {
      final doc = conversationsCollection.doc(message.conversationId);
      final currentConversationDoc = await doc.get();
      if (currentConversationDoc.exists) {
        final data = ConversationDto.fromJson(
                currentConversationDoc.data()!, message.senderId)
            .copyWithMessageDto(message)
            .read(read: false);
        await doc.set(data.toJson()); //update already existing and return null
        return null;
      }
      final currentUser = await PersistentStorage.getCurrentUser();
      if (currentUser == null) {
        return null;
      }

      final membersInfo = [
        message.toConversationUser(),
        ConversationUser(
            name: currentUser.name,
            accountType: currentUser.accountType,
            userId: currentUser.userId ?? '',
            avatar: currentUser.avatar ?? AppConstants.avatar)
      ];
      final convo = ConversationDto(
          lastMessage: message.text,
          id: doc.id,
          seen: false,
          lastMessageSenderId: currentUser.userId,
          membersInfo: membersInfo,
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
      final payload = body.copyWith(conversationId: convo?.id, id: doc.id);
      await doc.set(payload.toJson());
      return convo?.id;
    } catch (e) {
      throw BaseExceptions('Unable to send message');
    }
  }

  @override
  Stream<List<MessageDto>> onNewMessage(String userId) {
    return messagesCollection
        .where(MessageDto.keyReceiverId, isEqualTo: userId)
        .limitToLast(1)
    .orderBy(MessageDto.keyConversationId)
        .snapshots()
        .map(
            (e) => e.docs.map((_e) => MessageDto.fromJson(_e.data())).toList());
  }
}
