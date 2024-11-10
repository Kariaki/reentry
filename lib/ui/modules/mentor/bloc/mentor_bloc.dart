import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/mentor/mentor_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_event.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_state.dart';

class MentorBloc extends Bloc<MentorEvent, MentorState> {
  MentorBloc() : super(MentorStateInitial()) {
    on<RequestMentorEvent>(_requestMentor);
  }

  final _repo = MentorRepository();

  Future<void> _requestMentor(
      RequestMentorEvent event, Emitter<MentorState> emit) async {
    emit(MentorStateLoading());
    try {
      final user = await PersistentStorage.getCurrentUser();
      if (user == null) {
        emit(MentorStateError('User not found'));
        return;
      }
      final result =
          await _repo.requestMentor(event.data.copyWith(userId: user.userId));
      emit(MentorStateSuccess(result));
    } catch (e) {
      emit(MentorStateError(e.toString()));
    }
  }
}
