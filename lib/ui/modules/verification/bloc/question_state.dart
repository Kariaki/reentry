import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class VerificationQuestionCubitState {
  final CubitState? state;
  final List<VerificationQuestionDto> questions;

  VerificationQuestionCubitState({this.state, this.questions = const []});

  VerificationQuestionCubitState copyWith(
          {CubitState? state, List<VerificationQuestionDto>? questions}) =>
      VerificationQuestionCubitState(
          state: state ?? this.state, questions: questions ?? this.questions);

  VerificationQuestionCubitState loading() =>
      copyWith(state: CubitStateLoading());

  VerificationQuestionCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  VerificationQuestionCubitState success(List<VerificationQuestionDto> data) =>
      copyWith(questions: data, state: CubitStateSuccess());
}

sealed class QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionError extends QuestionState {
  final String error;

  QuestionError(this.error);
}

class QuestionSuccess extends QuestionState {}
