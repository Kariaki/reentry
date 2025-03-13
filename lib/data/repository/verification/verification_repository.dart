import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/data/repository/verification/verification_request_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';

final questionCollection = FirebaseFirestore.instance.collection("questions");

final collection = FirebaseFirestore.instance.collection("user");

class VerificationRepository {
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

  static void uploadDummyQuestions() async {
    List<String> verificationQuestions = [
      "What is the primary reason for using our app?",
      "Are you using this app for personal or business purposes?",
      "What specific features are you most interested in?",
      "How did you hear about our app?",
      "What industry or field do you work in?",
      "Do you plan to use this app daily, weekly, or occasionally?",
      "What problem are you trying to solve with our app?",
      "Have you used similar apps before? If yes, which ones?",
      "Are you signing up as an individual or on behalf of an organization?",
      "Do you require any special features or customizations?",
      "How do you intend to engage with other users on the platform?",
      "Will you be making any transactions through the app?",
      "What is your preferred method of communication for support or updates?",
      "Do you have any security or privacy concerns regarding your usage?",
      "Would you be interested in providing feedback to help improve the app?"
    ];

    for (var question in verificationQuestions) {
      final doc = questionCollection.doc();
      final data = VerificationQuestionDto(
          id: doc.id,
          question: question,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String());
      await doc.set(data.json());
    }
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

  Future<UserDto> submitForm(UserDto user, VerificationRequestDto form) async {
    user = user.copyWith(
        verification: form,
        verificationStatus: VerificationStatus.pending.name);
    //todo update user form
    await PersistentStorage.cacheUserInfo(user);
    await collection.doc(user.userId).set(user.toJson());
    return user;
  }

  Future<void> updateForm(UserDto user, VerificationStatus status,
      {String? rejectReason}) async {
    final form = user.verification?.copyWith(
        verificationStatus: status.name, rejectionReason: rejectReason);
   final  newuser = user.copyWith(verification: form, verificationStatus: status.name);
    //todo update user verification form
    print('verification -> ${newuser.toJson()}');
    await collection.doc(user.userId).set(newuser.toJson());
  }
}
