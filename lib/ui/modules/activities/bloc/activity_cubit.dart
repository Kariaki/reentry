import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/activities/activity_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'activity_state.dart';

class StatsDto {
  final int total;
  final int completed;

  const StatsDto({required this.total, required this.completed});
}

final _repo = ActivityRepository();

class ActivityCubit extends Cubit<ActivityCubitState> {
  ActivityCubit() : super(ActivityCubitState.init());

  Future<void> fetchActivities({String? userId}) async {
    try {
      emit(state.loading());
      final user = await PersistentStorage.getCurrentUser();
      final result = await _repo.fetchAllUsersActivityStream(userId: user?.userId??'');
      result.listen((result) {
        final activities = result.where((e) {
          return e.progress < 100 &&
              DateTime.fromMillisecondsSinceEpoch(e.startDate)
                  .add(Duration(days: 1))
                  .isAfter(DateTime.now());
        }).toList();
        final history = result.where((e) {
          return e.progress >= 100 ||
              DateTime.fromMillisecondsSinceEpoch(e.startDate)
                  .add(Duration(days: 1))
                  .isBefore(DateTime.now());
        }).toList();
        emit(state.success(activity: activities, history: history));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> fetchHistory() async {
    // try {
    //   emit(state.loading());
    //   final result = await _repo.fetchActivityHistory();
    //   result.listen((result) {
    //     emit(state.success(history: result));
    //   });
    // } catch (e) {
    //   emit(state.error(e.toString()));
    // }
  }

  Future<void> deleteActivity(String id) async {
    try {
      emit(state.loading());
      await _repo.deleteActivity(id);
      final updatedActivities =
          state.activity.where((item) => item.id != id).toList();
      emit(state.success(activity: updatedActivities));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}

Future<StatsDto> activityState(String userId) async {
  try {
    final result = await _repo.fetchAllUsersActivity(userId);

    final total = result.length;
    final done = result.where((e) => e.progress < 100).length;
    return StatsDto(total: total, completed: done);
  } catch (e) {
    return StatsDto(total: 1, completed: 0);
  }
}
