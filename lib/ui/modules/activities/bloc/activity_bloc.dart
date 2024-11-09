import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/activities/activity_repository.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'activity_event.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial()) {
    on<CreateActivityEvent>(_createActivity);
    on<UpdateActivityEvent>(_updateActivity);
    on<DeleteActivityEvent>(_deleteActivity);
  }

  final _repo = ActivityRepository();

  Future<void> _deleteActivity(
      DeleteActivityEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      await _repo.deleteActivity(event.id);
      emit(DeleteActivitySuccess());
    } catch (e) {
      emit(CreateActivityError(e.toString()));
    }
  }

  Future<void> _createActivity(
      CreateActivityEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      final result = await _repo.createActivity(event);
      emit(CreateActivitySuccess(result));
    } catch (e) {
      emit(CreateActivityError(e.toString()));
    }
  }

  Future<void> _updateActivity(
      UpdateActivityEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoading());
    try {
      await _repo.updateActivity(event.data);
      emit(ActivityUpdateSuccess());
    } catch (e) {
      emit(CreateActivityError(e.toString()));
    }
  }
}
