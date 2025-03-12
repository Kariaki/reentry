import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_state.dart';
import '../../../../data/repository/verification/verification_repository.dart';

class VerificationRequestCubit extends Cubit<VerificationRequestCubitState> {
  VerificationRequestCubit() : super(VerificationRequestCubitState());
  final _repository = VerificationRepository();

  void fetchQuestions() {
    emit(state.loading());
    try {
      _repository
          .getAllUsersVerificationRequest(VerificationStatus.pending)
          .listen((value) {
        emit(state.success(data: value));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void updateRequest(UserDto user, VerificationStatus status) async {
    try {
      emit(state.loading());
      await _repository.updateForm(user, status);
      emit(state.success(
          state: status == VerificationStatus.verified
              ? VerificationAccepted()
              : VerificationRejected()));
    } catch (e) {
      emit(state.error((e.toString())));
    }
  }

  void submitVerification(UserDto user) async {
    try {
      emit(state.loading());
      await _repository.updateForm(user, VerificationStatus.pending);
      emit(state.success(state: VerificationSubmitted()));
    } catch (e) {
      emit(state.error((e.toString())));
    }
  }
}
