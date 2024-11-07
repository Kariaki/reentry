import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalState {}

class GoalInitial extends GoalState {}

class GoalsLoading extends GoalState {}

class GoalSuccess extends GoalState {}

class DeleteGoalSuccess extends GoalState {}

class GoalUpdateSuccess extends GoalState {}

class CreateGoalSuccess extends GoalState {
  final GoalDto goal;

  CreateGoalSuccess(this.goal);
}

class GoalError extends GoalState {
  final String message;

  GoalError(this.message);
}

class GoalCubitState {
  List<GoalDto> goals;
  List<GoalDto> history;
  final GoalState state;

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
