import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalAndActivityState {}

class GoalInitial extends GoalAndActivityState {}

class GoalsLoading extends GoalAndActivityState {}

class GoalSuccess extends GoalAndActivityState {}

class DeleteGoalSuccess extends GoalAndActivityState {}

class GoalUpdateSuccess extends GoalAndActivityState {}

class CreateGoalSuccess extends GoalAndActivityState {
  final GoalDto goal;

  CreateGoalSuccess(this.goal);
}


class GoalError extends GoalAndActivityState {
  final String message;

  GoalError(this.message);
}

class GoalCubitState {
  List<GoalDto> goals;
  List<GoalDto> history;
  List<GoalDto> all;
  final GoalAndActivityState state;

  GoalCubitState(
      {this.goals = const [], this.history = const [], required this.state,this.all=const []});

  static GoalCubitState init() => GoalCubitState(
        state: GoalInitial(),
      );

  GoalCubitState loading() => GoalCubitState(
        state: GoalsLoading(),
      );

  GoalCubitState success({List<GoalDto>? goals, List<GoalDto>? history, List<GoalDto>? all}) =>
      GoalCubitState(
          state: GoalSuccess(),
          goals: goals ?? this.goals,
          all: all??this.all,
          history: history ?? this.history);

  GoalCubitState error(String error) =>
      GoalCubitState(state: GoalError(error), goals: goals, history: history,all: all);
}
