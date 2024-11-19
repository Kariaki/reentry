import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientStateInitial());

  final _repo = ClientRepository();

  Future<void> fetchClients() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserClients();
      emit(ClientDataSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> fetchClientsByUserId(String userId) async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserClients(userId: userId);
      emit(ClientDataSuccess(result));
    } catch (e) {
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
