import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/ui/components/message_snackbar.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/model/messaging/conversation_dto.dart';
import '../../../../data/repository/messaging/messaging_repository.dart';
import '../../../../data/shared/share_preference.dart';

class ConversationCubit extends Cubit<MessagingState> {
  final _repo = MessageRepository();

  ConversationCubit() : super(MessagingState());

  StreamSubscription<List<ConversationDto>>? _listener;
  StreamSubscription<List<MessageDto>>? _onNewMessageListener;

  Future<void> onNewMessage(BuildContext context) async {
    _onNewMessageListener?.cancel();
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    _onNewMessageListener =
        _repo.onNewMessage(user.userId ?? '').listen((result) {
      final message = result.firstOrNull;
      if (message == null) {
        return;
      }
      context.showCustomSnackBar(
          context,
          MessageSnackbar(
              message: message.text,
              timestamp: message.timestamp??0,
              avatar: 'avatar'));
      //todo display the message notification and play sound
    });
  }

  Future<void> listenForConversationsUpdate() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    emit(ConversationLoading());
    final result = _repo.fetchConversations(user.userId!);
    _listener = result.listen((result) {
      emit(ConversationSuccessState(result));
    });
  }

  void cancel() {
    _listener?.cancel();
    _onNewMessageListener?.cancel();
    _onNewMessageListener = null;
    _listener = null;
  }
}
