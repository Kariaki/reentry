import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/verification/verification_repository.dart';
import 'package:reentry/ui/modules/verification/bloc/question_event.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';

class VerificationQuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  VerificationQuestionBloc() : super(QuestionInitial()) {
    on<CreateQuestionEvent>(_createQuestion);
    on<DeleteQuestionEvent>(_deleteQuestion);
    on<UpdateQuestionEvent>(_updateQuestion);
  }

  final _repo = VerificationRepository();

  Future<void> _createQuestion(
      CreateQuestionEvent event, Emitter<QuestionState> emit) async {
    try {
      emit(QuestionLoading());
      await _repo.createQuestion(event.question);
      emit(QuestionCreatedSuccess());
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

  Future<void> _deleteQuestion(
      DeleteQuestionEvent event, Emitter<QuestionState> emit) async {
    try {
      emit(QuestionLoading());
      await _repo.deleteQuestion(event.id);
      emit(QuestionDeletedSuccess());
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

  Future<void> _updateQuestion(
      UpdateQuestionEvent event, Emitter<QuestionState> emit) async {
    try {
      emit(QuestionLoading());
      await _repo.updateQuestion(event.question);
      emit(QuestionUpdatedSuccess());
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }
}
