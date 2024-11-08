import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/data/model/goal_dto.dart';

sealed class GoalsAndActivityEvent {}

class CreateGoalEvent extends GoalsAndActivityEvent {
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


class DeleteActivityEvent extends GoalsAndActivityEvent{
  final String id;
  DeleteActivityEvent(this.id);
}
class UpdateGoalEvent extends GoalsAndActivityEvent {
  GoalDto goal;

  UpdateGoalEvent(this.goal);
}
class DeleteGoalEvent extends GoalsAndActivityEvent{
  final String id;
  DeleteGoalEvent(this.id);
}