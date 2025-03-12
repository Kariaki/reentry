import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import '../../../../data/repository/verification/verification_repository.dart';

class VerificationQuestionCubit extends Cubit<VerificationQuestionCubitState> {
  VerificationQuestionCubit() : super(VerificationQuestionCubitState());
  final _repository = VerificationRepository();

  void fetchQuestions() {
    emit(state.loading());
    try {
      _repository.getAllQuestions().listen((value) {
        emit(state.success(value,value));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
  void search(String query){

    final data = state.allQuestions.where((e)=>e.question.toLowerCase().contains(query.toLowerCase())).toList();
    emit(state.success(data,state.allQuestions));
  }
  void uploadDummyQuestions()async{
   //  VerificationRepository.uploadDummyQuestions();
  }
}
