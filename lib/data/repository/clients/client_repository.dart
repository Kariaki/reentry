import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/repository/clients/client_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';

class ClientRepository extends ClientRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("clients");

  @override
  Future<List<ClientDto>> getRecommendedClients() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return [];
    }
    final results = await collection
        //.where(ClientDto.assigneesKey, arrayContains: user.userId ?? '')
        .where(ClientDto.statusKey, isEqualTo: ClientStatus.pending.index)
        .get();
    return results.docs
        .map((e) => ClientDto.fromJson(e.data()))
        .toList();
  }

  @override
  Future<List<ClientDto>> getUserClients() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return [];
    }
    final results = await collection
        .where(ClientDto.assigneesKey, arrayContains: user.userId ?? '')
        .where(ClientDto.statusKey, isEqualTo: ClientStatus.active.index)
        .get();
    return results.docs
        .map((e) => ClientDto.fromJson(e.data()))
        .toList();
  }

  @override
  Future<void> updateClient(ClientDto client) async {
    final doc = collection.doc(client.id);
    await doc.set(client.toJson());
  }
}
