import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/mentor_request.dart';
import 'package:reentry/data/repository/mentor/mentor_repository_interface.dart';
import 'package:reentry/exception/app_exceptions.dart';

class MentorRepository extends MentorRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("mentorRequest");

  @override
  Future<MentorRequest> requestMentor(MentorRequest data) async {
    try {
      final doc = collection.doc();
      final payload = data.copyWith(id: doc.id);
      //todo if user already have a mentor request it should be replaced
      await doc.set(payload.toJson());
      return payload;
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
