import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class VerificationQuestionCubitState {
  final CubitState? state;
  final List<VerificationQuestionDto> questions;
  final List<VerificationQuestionDto> allQuestions;

  VerificationQuestionCubitState({this.state, this.questions = const [], this.allQuestions = const []});

  VerificationQuestionCubitState copyWith(
          {CubitState? state, List<VerificationQuestionDto>? questions, List<VerificationQuestionDto>? allQuestions}) =>
      VerificationQuestionCubitState(
          state: state ?? this.state, questions: questions ?? this.questions, allQuestions: allQuestions ?? this.allQuestions);

  VerificationQuestionCubitState loading() =>
      copyWith(state: CubitStateLoading());

  VerificationQuestionCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  VerificationQuestionCubitState success(List<VerificationQuestionDto> data,List<VerificationQuestionDto> all) =>
      copyWith(questions: data, state: CubitStateSuccess(),allQuestions: all);
}

sealed class QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionError extends QuestionState {
  final String error;

  QuestionError(this.error);
}

class QuestionUpdatedSuccess extends QuestionState {}
class QuestionCreatedSuccess extends QuestionState {}
class QuestionDeletedSuccess extends QuestionState {}
