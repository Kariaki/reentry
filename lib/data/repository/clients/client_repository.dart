import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/repository/clients/client_repository_interface.dart';

class ClientRepository extends ClientRepositoryInterface{

  final collection = FirebaseFirestore.instance.collection("clients");

  @override
  void createClient() {
    // TODO: implement createClient
  }

  @override
  void deleteClient() {
    // TODO: implement deleteClient
  }

  @override
  void getRecommendedClients() {
    // TODO: implement getRecommendedClients
  }

  @override
  void getUserClients() {
    // TODO: implement getUserClients
  }

  @override
  void updateClient() {
    // TODO: implement updateClient
  }

}