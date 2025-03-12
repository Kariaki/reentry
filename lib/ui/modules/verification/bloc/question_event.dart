import 'package:reentry/data/model/verification_question.dart';

sealed class QuestionEvent {}

class CreateQuestionEvent extends QuestionEvent {
  final String question;

  CreateQuestionEvent(this.question);
}

class DeleteQuestionEvent extends QuestionEvent {
  final String id;

  DeleteQuestionEvent(this.id);
}

class UpdateQuestionEvent extends QuestionEvent {
  final VerificationQuestionDto question;
  UpdateQuestionEvent(this.question);
}
