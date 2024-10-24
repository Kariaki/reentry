import 'package:reentry/data/model/client_dto.dart';

class ClientState {}

class ClientLoading extends ClientState {}

class ClientStateInitial extends ClientState{}
class ClientError extends ClientState {
  final String error;

  ClientError(this.error);
}

class ClientDataSuccess extends ClientState {
  final List<ClientDto> data;

  ClientDataSuccess(this.data);
}

class ClientSuccess extends ClientState {
  final ClientDto client;

  ClientSuccess(this.client);
}
