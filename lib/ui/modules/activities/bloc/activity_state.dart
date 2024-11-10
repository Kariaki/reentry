import 'package:reentry/data/model/activity_dto.dart';

sealed class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitySuccess extends ActivityState {}

class DeleteActivitySuccess extends ActivityState {}

class UpdateActivitySuccess extends ActivityState {}

class ActivityUpdateSuccess extends ActivityState {}

class CreateActivitySuccess extends ActivityState {
  final ActivityDto goal;

  CreateActivitySuccess(this.goal);
}

class ActivityError extends ActivityState {
  final String message;

  ActivityError(this.message);
}
class CreateActivityError extends ActivityState {
  final String message;

  CreateActivityError(this.message);
}

class ActivityCubitState {
  List<ActivityDto> activity;
  List<ActivityDto> history;
  final ActivityState state;

  ActivityCubitState(
      {this.activity = const [], this.history = const [], required this.state});

  static ActivityCubitState init() => ActivityCubitState(
        state: ActivityInitial(),
      );

  ActivityCubitState loading() => ActivityCubitState(
        state: ActivityLoading(),
      );

  ActivityCubitState success(
          {List<ActivityDto>? activity, List<ActivityDto>? history}) =>
      ActivityCubitState(
          state: ActivitySuccess(),
          activity: activity ?? this.activity,
          history: history ?? this.history);

  ActivityCubitState error(String error) => ActivityCubitState(
      state: ActivityError(error), activity: activity, history: history);
}
