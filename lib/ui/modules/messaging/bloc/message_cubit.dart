import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/repository/messaging/messaging_repository.dart';

class MessageCubit extends Cubit<MessagingState> {
  MessageCubit() : super(MessagingState());

  final _repo = MessageRepository();

  Future<void> sendMessage(
      SendMessageEvent body, Function(String?) conversationResult) async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    final payload = body.toMessageDto().copyWith(senderId: user.userId,);

    if (body.conversationId == null) {
      emit(MessagesSuccessState([
        MessageDto(
            senderId: user.userId ?? '',
            receiverInfo: body.receiverInfo,
            receiverId: body.receiverId,

            timestamp: DateTime.now().millisecondsSinceEpoch,
            text: body.text)
      ]));
    }
    final result = await _repo.sendMessage(payload);
    if (result != null) {
      conversationResult(result);
      streamMessage(result);
    }
  }

  Future<void> streamMessage(String? conversationId) async {
    emit(MessagingState());
    if (conversationId == null) {
      return;
    }
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    emit(MessagingLoading());
    try {
      final result = _repo.fetchRoomMessages(conversationId);
      result.listen((result) {
        emit(MessagesSuccessState(result));
        readConversation(conversationId, true);
      });
    } catch (e) {
      emit(MessagingError(e.toString()));
    }
  }

  Future<void> readConversation(String? conversationId,bool shouldRead) async {
    if(conversationId==null){
      return;
    }
    if(!shouldRead){
      return;
    }
    try {
      await _repo.readConversation(conversationId);
    } catch (e) {}
  }
}
