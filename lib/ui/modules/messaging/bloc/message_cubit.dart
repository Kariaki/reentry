import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/repository/messaging/messaging_repository.dart';

class MessageCubit extends Cubit<MessagingState> {
  MessageCubit() : super(MessagingState());

  final _repo = MessageRepository();

  Future<void> sendMessage(
    SendMessageEvent body,
  ) async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    final payload = body.toMessageDto().copyWith(senderId: user.userId);

    final result = await _repo.sendMessage(payload);
    if (result != null) {
      await streamMessage(result);
    }
  }

  Future<void> streamMessage(String? conversationId) async {
    if(conversationId==null){
      return;
    }
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    emit(MessagingLoading());
    print('********* fetching ***** fetching messages for $conversationId');
    try {
      final result = _repo.fetchRoomMessages(conversationId);
      result.listen((result) {
        emit(MessagesSuccessState(result));
      });
    } catch (e) {
      print('firebase error ${e.toString()}');
      emit(MessagingError(e.toString()));
    }
  }
}
