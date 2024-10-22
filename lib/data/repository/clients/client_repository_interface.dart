import 'package:reentry/data/model/client_dto.dart';

abstract class ClientRepositoryInterface{
  Future<List<ClientDto>> getUserClients();
  Future<List<ClientDto>> getRecommendedClients();
  Future<void> updateClient(ClientDto client);
}