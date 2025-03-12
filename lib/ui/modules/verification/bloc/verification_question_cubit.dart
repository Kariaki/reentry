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
        emit(state.success(value));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
