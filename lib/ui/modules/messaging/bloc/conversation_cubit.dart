import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import '../../../../data/repository/messaging/messaging_repository.dart';
import '../../../../data/shared/share_preference.dart';

class ConversationCubit extends Cubit<MessagingState> {
  final _repo = MessageRepository();

  ConversationCubit() : super(MessagingState());

  Future<void> listenForConversationsUpdate() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    emit(ConversationLoading());
    final result = _repo.fetchConversations(user.userId!);
    result.listen((result) {
      emit(ConversationSuccessState(result));
    });
  }
}
