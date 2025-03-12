import 'package:flutter_bloc/flutter_bloc.dart';
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

  void submitForm(){
    //todo submit form
  }
  void addAnswerAndShowNext(String answer) {
    final currentQuestion = state.currentQuestion;
    Map<String,String> response = {
      ...state.response
    };
    response[currentQuestion?.id ?? ''] = answer;
    final currentIndex = state.questions.indexWhere((e)=>e.id==currentQuestion?.id);
    if(currentIndex!=-1 && currentIndex<state.questions.length-1) {
      emit(state.success(
          response: response, currentQuestion: state.questions[currentIndex+1]));
    }
  }

  void previousQuestion(int index) {
    if (index >= 0) {
      emit(state.success(currentQuestion: state.questions[index]));
    }
  }
}
