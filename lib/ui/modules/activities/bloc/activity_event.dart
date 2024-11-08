import 'package:reentry/data/model/activity_dto.dart';

sealed class ActivityEvent {}
class CreateActivityEvent extends ActivityEvent {
  final int startDate;
  final int endDate;
  final String title;
  final Frequency frequency;

   CreateActivityEvent(
      {required this.endDate,
      required this.startDate,
      required this.title,
      required this.frequency});
}
