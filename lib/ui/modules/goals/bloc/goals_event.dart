import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalsEvent {}

class CreateGoalEvent extends GoalsEvent {
  final String title;
  final int startDate;
  final int endDate;

  CreateGoalEvent(this.title, this.startDate, this.endDate);

  GoalDto toGoalDto() {
    return GoalDto(
        id: '',
        userId: '',
        title: title,
        createdAt: DateTime.fromMillisecondsSinceEpoch(startDate),
        endDate: DateTime.fromMillisecondsSinceEpoch(endDate));
  }
}

class UpdateGoalEvent extends GoalsEvent {
  GoalDto goal;

  UpdateGoalEvent(this.goal);
}
class DeleteGoalEvent extends GoalsEvent{
  final String id;
  DeleteGoalEvent(this.id);
}