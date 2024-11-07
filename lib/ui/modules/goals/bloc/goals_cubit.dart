import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/goals/goals_repository.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';

class GoalCubit extends Cubit<GoalState> {
  GoalCubit() : super(GoalInitial());
  final _repo = GoalRepository();

  Future<void> fetchGoals() async {
    try {
      emit(GoalsLoading());
      final result = await _repo.fetchActiveGoals();
      result.listen((result) {
        emit(GoalDataSuccess(result));
      });
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
