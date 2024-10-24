import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/repository/messaging/messaging_repository.dart';

class MessageCubit extends Cubit<MessagingState> {
  MessageCubit() : super(MessagingState());

  final _repo = MessageRepository();

  Future<void> sendMessage(SendMessageEvent body) async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    final payload = body.toMessageDto().copyWith(senderId: user.userId);
    _repo.sendMessage(payload);
  }

  Future<void> streamMessage(String receiverId) async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    final result = _repo.fetchRoomMessages(user.userId!, receiverId);
    result.listen((result) {
      emit(MessagesSuccessState(result));
    });
  }
}
