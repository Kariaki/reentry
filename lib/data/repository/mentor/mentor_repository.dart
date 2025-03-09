import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/mentor_request.dart';
import 'package:reentry/exception/app_exceptions.dart';

import 'mentor_repository_interface.dart';

class MentorRepository extends MentorRepositoryInterface {
  final clients = FirebaseFirestore.instance.collection("clients");

  @override
  Future<MentorRequest> requestMentor(MentorRequest data) async {
    try {
      //  final doc = collection.doc();
      //   final payload = data.copyWith(id: doc.id);
      final clientDoc = clients.doc(data.userId);
      final clientPayload = data.toClient().copyWith(id: data.userId);
      //todo if user already have a mentor request it should be replaced
      //    await doc.set(payload.toJson());
      await clientDoc.set(clientPayload.toJson());
      return data;
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
