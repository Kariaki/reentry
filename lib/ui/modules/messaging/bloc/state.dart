import 'package:reentry/data/model/messaging/conversation_dto.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';

class MessagingState {}

class ConversationSuccessState extends MessagingState {
  final List<ConversationDto> data;

  ConversationSuccessState(this.data);
}

class MessagesSuccessState extends MessagingState {
  final List<MessageDto> data;

  MessagesSuccessState(this.data);
}

class MessagingError extends MessagingState {
  final String error;

  MessagingError(this.error);
}

class MessagingLoading extends MessagingState {}
