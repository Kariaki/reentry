import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/goals/goals_repository.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';

class GoalCubit extends Cubit<GoalCubitState> {
  GoalCubit() : super(GoalCubitState.init());
  final _repo = GoalRepository();

  Future<void> fetchGoals() async {
    try {
      emit(state.loading());
      final result = await _repo.fetchActiveGoals();
      result.listen((result) {
        emit(state.success(goals: result));
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
}
