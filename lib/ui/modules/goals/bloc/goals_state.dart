import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalState{}
class GoalInitial extends GoalState{}

class GoalsLoading extends GoalState{}
class GoalSuccess extends GoalState{}
class DeleteGoalSuccess extends GoalState{}
class GoalUpdateSuccess extends GoalState{}
class CreateGoalSuccess extends GoalState{
  final GoalDto goal;
  CreateGoalSuccess(this.goal);
}

class GoalError extends GoalState{
  final String message;
  GoalError(this.message);
}
class GoalDataSuccess extends GoalState{
  List<GoalDto> goals;
  GoalDataSuccess(this.goals);
}