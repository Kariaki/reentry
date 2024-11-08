import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/goals/goals_repository.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';

class GoalsAndActivityBloc extends Bloc<GoalsAndActivityEvent, GoalAndActivityState> {
  GoalsAndActivityBloc() : super(GoalInitial()) {
    on<CreateGoalEvent>(_createGoal);
    on<UpdateGoalEvent>(_update);
    on<DeleteGoalEvent>(_deleteGoal);
    on<DeleteActivityEvent>(_deleteActivity);
  }
  Future<void> _createActivity(CreateActivityEvent event,Emitter<GoalAndActivityState> emit)async{}

  Future<void> _deleteActivity(DeleteActivityEvent event,Emitter<GoalAndActivityState> emit)async{}
 // Future<void> _updateActivity(DeleteActivityEvent event,Emitter<GoalAndActivityState> emit)async{}

  Future<void> _deleteGoal(
      DeleteGoalEvent event, Emitter<GoalAndActivityState> emit) async {
    try {
      emit(GoalsLoading());
      await _repo.deleteGoals(event.id);
      emit(DeleteGoalSuccess());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  final _repo = GoalRepository();

  Future<void> _createGoal(
      CreateGoalEvent event, Emitter<GoalAndActivityState> emit) async {
    try {
      emit(GoalsLoading());
      final result = await _repo.createGoal(event);
      emit(CreateGoalSuccess(result));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _update(UpdateGoalEvent event, Emitter<GoalAndActivityState> emit) async {
    try {
      emit(GoalsLoading());
      await _repo.updateGoal(event.goal);
      emit(GoalUpdateSuccess());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
