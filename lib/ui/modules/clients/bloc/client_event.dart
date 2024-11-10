import 'package:reentry/data/model/client_dto.dart';
class ClientEvent{}

class ClientActionEvent extends ClientEvent{
  ClientDto client;
  ClientActionEvent(this.client);
}
