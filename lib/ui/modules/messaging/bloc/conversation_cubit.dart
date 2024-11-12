import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/model/messaging/conversation_dto.dart';
import '../../../../data/repository/messaging/messaging_repository.dart';
import '../../../../data/shared/share_preference.dart';

class ConversationCubit extends Cubit<MessagingState> {
  final _repo = MessageRepository();

  ConversationCubit() : super(MessagingState());

  StreamSubscription<List<ConversationDto>>? _listener;

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
    _listener = null;
  }
}
