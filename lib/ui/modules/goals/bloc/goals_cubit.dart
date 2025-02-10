import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/data/repository/goals/goals_repository.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';

import '../../activities/bloc/activity_cubit.dart';

final _repo = GoalRepository();

class GoalCubit extends Cubit<GoalCubitState> {
  GoalCubit() : super(GoalCubitState.init());
/*
   .where(
          GoalDto.keyProgress,
          isLessThan: 100,
        )
        .orderBy(GoalDto.keyCreatedAt, descending: true)
 */
  Future<void> fetchGoals({String? userId}) async {
    try {
      emit(state.loading());
      final result = await _repo.fetchActiveGoals(userId: userId);
      result.listen((result) {
        final data = result.where((e) => e.progress < 100).toList();
        emit(state.success(goals: data, all: result));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> fetchHistory() async {
    try {
      emit(state.loading());
      final result = await _repo.fetchGoalHistory();
      result.listen((result) {
        emit(state.success(history: result));
      });
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      emit(state.loading());
      await _repo.deleteGoals(id);
      emit(state.success());
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  Future<void> updateGoal(GoalDto goal) async {
    try {
      emit(state.loading());
      await _repo.updateGoal(goal);
      emit(state.success());
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}


Future<StatsDto> goalStats(String userId) async {

  try {
    print('kariaki11 -> ');
    final result = await _repo.fetchAllUserGoals(userId);
    final total = result.length;
    final done = result
        .where((e) => e.progress < 100)
        .length;
    return StatsDto(total: total, completed: done);
  }catch(e){

    return StatsDto(total: 1, completed: 0);
  }
}