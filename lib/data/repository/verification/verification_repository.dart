import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/data/repository/verification/verification_request_dto.dart';

class VerificationRepository {
  final questionCollection = FirebaseFirestore.instance.collection("questions");

  final collection = FirebaseFirestore.instance.collection("user");

  Future<void> createQuestion(String question) async {
    final doc = questionCollection.doc();
    final data = VerificationQuestionDto(
        id: doc.id,
        question: question,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String());
    await doc.set(data.json());
  }

  Future<void> updateQuestion(VerificationQuestionDto question) async {
    question = question.copyWith(updatedAt: DateTime.now().toIso8601String());
    await questionCollection.doc(question.id).set(question.json());
  }

  Future<void> deleteQuestion(String? id) async {
    if (id == null) {
      return;
    }
    await questionCollection.doc(id).delete();
  }

  Future<List<VerificationQuestionDto>> fetchQuestions() async {
    final result = await questionCollection.get();
    return result.docs
        .map((e) => VerificationQuestionDto.fromJson(e.data()))
        .toList();
  }

  Stream<List<VerificationQuestionDto>> getAllQuestions() {
    return questionCollection.snapshots().map((value) {
      return value.docs
          .map((e) => VerificationQuestionDto.fromJson(e.data()))
          .toList();
    });
  }

  Stream<List<UserDto>> getAllUsersVerificationRequest(
      VerificationStatus status) {
    return collection
        .where(UserDto.keyVerificationStatus, isEqualTo: status.name)
        .snapshots()
        .map((value) {
      return value.docs.map((e) => UserDto.fromJson(e.data())).toList();
    });
  }

  Future<void> updateSubmitForm(
      UserDto user, VerificationRequestDto form) async {
    user = user.copyWith(verification: form);
    //todo update user form
    await collection.doc(user.userId).set(user.toJson());
  }

  Future<void> updateForm(UserDto user, VerificationStatus status,
      {String? rejectReason}) async {
    final form = user.verification?.copyWith(
        verificationStatus: status.name, rejectionReason: rejectReason);
    user = user.copyWith(verification: form);
    //todo update user verification form
    await collection.doc(user.userId).set(user.toJson());
  }
}
