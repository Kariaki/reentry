import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';

class ClientState {}

class ClientLoading extends ClientState {}

class ClientStateInitial extends ClientState{}
class ClientError extends ClientState {
  final String error;

  ClientError(this.error);
}

class ClientDataSuccess extends ClientState {
  final List<ClientDto> data;
  final String? message;

  ClientDataSuccess(this.data,{this.message});
}
class UserDataSuccess extends ClientState {
  final List<UserDto> data;

  UserDataSuccess(this.data);
}

class ConversationUserStateSuccess extends ClientState {
  final Map<String,ConversationUserEntity> data;

  ConversationUserStateSuccess(this.data);
}

class ClientSuccess extends ClientState {
  final ClientDto client;

  ClientSuccess(this.client);
}
