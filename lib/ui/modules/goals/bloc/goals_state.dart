import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalAndActivityState {}

class GoalInitial extends GoalAndActivityState {}

class GoalsLoading extends GoalAndActivityState {}
class ActivityLoading extends GoalAndActivityState {}

class GoalSuccess extends GoalAndActivityState {}

class DeleteGoalSuccess extends GoalAndActivityState {}
class DeleteActivitySuccess extends GoalAndActivityState {}

class GoalUpdateSuccess extends GoalAndActivityState {}
class ActivityUpdateSuccess extends GoalAndActivityState {}

class CreateGoalSuccess extends GoalAndActivityState {
  final GoalDto goal;

  CreateGoalSuccess(this.goal);
}
class ActivityError extends GoalAndActivityState{
  final String message;
  ActivityError(this.message);
}
class CreateActivitySuccess extends GoalAndActivityState {
  final ActivityDto activity;

  CreateActivitySuccess(this.activity);
}

class GoalError extends GoalAndActivityState {
  final String message;

  GoalError(this.message);
}

class GoalCubitState {
  List<GoalDto> goals;
  List<GoalDto> history;
  final GoalAndActivityState state;

  GoalCubitState(
      {this.goals = const [], this.history = const [], required this.state});

  static GoalCubitState init() => GoalCubitState(
        state: GoalInitial(),
      );

  GoalCubitState loading() => GoalCubitState(
        state: GoalsLoading(),
      );

  GoalCubitState success({List<GoalDto>? goals, List<GoalDto>? history}) =>
      GoalCubitState(
          state: GoalSuccess(),
          goals: goals ?? this.goals,
          history: history ?? this.history);

  GoalCubitState error(String error) =>
      GoalCubitState(state: GoalError(error), goals: goals, history: history);
}
