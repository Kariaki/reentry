import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';

import '../../../../data/repository/messaging/messaging_repository.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientStateInitial());

  final _repo = ClientRepository();
  final _messageRepo = MessageRepository();

  Future<void> fetchClients() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserClients();
      emit(ClientDataSuccess(result,message: null));
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace);
      emit(ClientError(e.toString()));
    }
  }

  Future<void> unmatch(String userId, String clientId) async {
    try {
      emit(ClientLoading());
      ClientDto? client = await _repo.getClientById(clientId);
      if (client != null) {
        client = client.copyWith(
            assignees: client.assignees.where((e) => e != userId).toList());
        await _repo.updateClient(client);
      }
      final result = await _repo.getUserClients();
      emit(ClientDataSuccess(result, message: 'Client unmatched'));
    } catch (e) {
      emit(ClientError(e.toString()));
      await Future.delayed(Duration(seconds: 1));
      fetchClientsByUserId(userId);
    }
  }

  Future<void> fetchClientsByUserId(String userId) async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserClients(userId: userId);

      emit(ClientDataSuccess(result));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      emit(ClientError(e.toString()));
    }
  }
}

class UserAssigneeCubit extends Cubit<ClientState> {
  UserAssigneeCubit() : super(ClientStateInitial());

  final _repo = UserRepository();

  Future<void> fetchAssignee() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserAssignee();
      emit(UserDataSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}

class ConversationUsersCubit extends Cubit<ClientState> {
  ConversationUsersCubit() : super(ClientStateInitial());

  final _repo = UserRepository();
  final _clientRepo = ClientRepository();

  Future<void> fetchConversationUsers({bool showLoader = false}) async {
    final currentUser = await PersistentStorage.getCurrentUser();
    print('**************************** ${currentUser?.userId}');
    if (currentUser == null) {
      return;
    }
    final Map<String, ConversationUserEntity> resultMap = {};
    try {
      if (showLoader) {
        emit(ClientLoading());
      }
      if (currentUser.accountType == AccountType.citizen) {
        final result = await _repo.getUserAssignee();
        for (var i in result) {
          resultMap[i.userId ?? ''] = i.toConversationUserEntity();
        }
      } else {
        final result = await _clientRepo.getUserClients();
        for (var i in result) {
          resultMap[i.id] = i.toConversationUserEntity();
        }
      }
      emit(ConversationUserStateSuccess(resultMap));
    } catch (e) {
      if (state is ConversationUserStateSuccess) {
        return;
      }
      emit(ClientError(e.toString()));
    }
  }
}

class RecommendedClientCubit extends Cubit<ClientState> {
  RecommendedClientCubit() : super(ClientStateInitial());

  final _repo = ClientRepository();

  Future<void> fetchRecommendedClients() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getRecommendedClients();
      emit(ClientDataSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}
