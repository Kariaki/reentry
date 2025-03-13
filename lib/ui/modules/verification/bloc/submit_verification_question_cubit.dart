import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/verification/verification_request_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import '../../../../data/repository/verification/verification_repository.dart';

class SubmitVerificationQuestionCubit
    extends Cubit<SubmitVerificationQuestionCubitState> {
  SubmitVerificationQuestionCubit()
      : super(SubmitVerificationQuestionCubitState());
  final _repository = VerificationRepository();

  void fetchQuestions() async {
    emit(state.loading());
    try {
      final questions = await _repository.fetchQuestions();
      print('kebilate1 -> ${questions.firstOrNull?.question}');
      emit(state.success(
          questions: questions, currentQuestion: questions.firstOrNull));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void nextQuestion(int index) {
    if (index == state.questions.length - 1) {
      return;
    }
    emit(state.success(currentQuestion: state.questions[index]));
  }

  void submitForm() async {
    final user = await PersistentStorage.getCurrentUser();
    if (user == null) {
      return;
    }
    try {
      emit(state.loading());
      final form = VerificationRequestDto(
          form: state.response,
          date: DateTime.now().toIso8601String(),
          verificationStatus: VerificationStatus.pending.name);
     final newUser =  await _repository.submitForm(user, form);
      emit(state.success(state: VerificationFormSubmitted(newUser)));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void seResponse(Map<String, String> response) {
    emit(state.success(response: response));
  }

  void addAnswerAndShowNext(String answer) {
    final currentQuestion = state.currentQuestion;
    Map<String, String> response = {...state.response};
    response[currentQuestion?.id ?? ''] = answer;
    final currentIndex =
        state.questions.indexWhere((e) => e.id == currentQuestion?.id);
    if (currentIndex != -1 && currentIndex < state.questions.length - 1) {
      emit(state.success(
          response: response,
          currentQuestion: state.questions[currentIndex + 1]));
    }
  }

  void previousQuestion(int index) {
    if (index >= 0) {
      emit(state.success(currentQuestion: state.questions[index]));
    }
  }
}
