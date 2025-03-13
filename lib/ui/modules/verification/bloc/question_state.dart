import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../../data/model/user_dto.dart';

class VerificationQuestionCubitState {
  final CubitState? state;
  final List<VerificationQuestionDto> questions;
  final List<VerificationQuestionDto> allQuestions;

  VerificationQuestionCubitState(
      {this.state, this.questions = const [], this.allQuestions = const []});

  VerificationQuestionCubitState copyWith(
          {CubitState? state,
          List<VerificationQuestionDto>? questions,
          List<VerificationQuestionDto>? allQuestions}) =>
      VerificationQuestionCubitState(
          state: state ?? this.state,
          questions: questions ?? this.questions,
          allQuestions: allQuestions ?? this.allQuestions);

  VerificationQuestionCubitState loading() =>
      copyWith(state: CubitStateLoading());

  VerificationQuestionCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  VerificationQuestionCubitState success(List<VerificationQuestionDto> data,
          List<VerificationQuestionDto> all) =>
      copyWith(questions: data, state: CubitStateSuccess(), allQuestions: all);
}

class SubmitVerificationQuestionCubitState {
  final CubitState? state;
  final List<VerificationQuestionDto> questions;
  final VerificationQuestionDto? currentQuestion;
  final Map<String, String> response;

  SubmitVerificationQuestionCubitState(
      {this.state,
      this.questions = const [],
      this.currentQuestion,
      this.response = const {}});

  SubmitVerificationQuestionCubitState copyWith(
          {CubitState? state,
          List<VerificationQuestionDto>? questions,
          VerificationQuestionDto? currentQuestion,
          Map<String, String>? response}) =>
      SubmitVerificationQuestionCubitState(
          state: state ?? this.state,
          currentQuestion: currentQuestion ?? this.currentQuestion,
          questions: questions ?? this.questions,
          response: response ?? this.response);

  SubmitVerificationQuestionCubitState loading() =>
      copyWith(state: CubitStateLoading());

  SubmitVerificationQuestionCubitState error(String message) =>
      copyWith(state: CubitStateError(message));

  SubmitVerificationQuestionCubitState success(
          {List<VerificationQuestionDto>? questions,
          Map<String, String>? response,
          VerificationQuestionDto? currentQuestion,CubitState? state}) =>
      copyWith(
          questions: questions ?? this.questions,
          state:state?? CubitStateSuccess(),
          response: response ?? this.response,
          currentQuestion: currentQuestion ?? this.currentQuestion);
}

class VerificationFormSubmitted extends CubitState{
  final UserDto user;
  VerificationFormSubmitted(this.user);
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
