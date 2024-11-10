import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';

class MessagingEvent {}

class SendMessageEvent extends MessagingEvent {
  final String text;
  final String? conversationId;
  final String receiverId;
  final ReceiverInfo receiverInfo;

  SendMessageEvent(
      {required this.receiverId, required this.text, this.conversationId,required this.receiverInfo});

  MessageDto toMessageDto() {
    return MessageDto(
        senderId: '',
        receiverInfo: receiverInfo,
        receiverId: receiverId,
        text: text,
        conversationId: conversationId);
  }
}

class NewMessageEvent extends MessagingEvent {
  final List<MessageDto> data;

  NewMessageEvent(this.data);
}

class NewConversationsEvent extends MessagingEvent {
  final List<ConversationDto> data;

  NewConversationsEvent(this.data);
}
