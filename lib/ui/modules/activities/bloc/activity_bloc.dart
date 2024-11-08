import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/activities/activity_repository.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';

import 'activity_event.dart';

class ActivityBloc extends Bloc<CreateActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial()) {
    on<CreateActivityEvent>(_createActivity);
  }

  final _repo = ActivityRepository();

  Future<void> _createActivity(
      CreateActivityEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      final result = await _repo.createGoal(event);
      emit(ActivitySuccess());
    } catch (e) {
      emit(CreateActivityError(e.toString()));
    }
  }
}
