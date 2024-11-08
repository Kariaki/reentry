import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/activities/activity_repository.dart';
import 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityCubitState> {
  ActivityCubit() : super(ActivityCubitState.init());
  final _repo = ActivityRepository();

  Future<void> fetchActivities() async {
    try {
      emit(state.loading());
      final result = await _repo.fetchActiveGoals();
      result.listen((result) {
        emit(state.success(activity: result));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> fetchHistory() async {
    try {
      emit(state.loading());
      final result = await _repo.fetchActivityHistory();
      result.listen((result) {
        emit(state.success(history: result));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
