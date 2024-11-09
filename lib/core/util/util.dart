import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';

class Utility {
  static List<DateTime> getDateRange(
      DateTime startDate, DateTime endDate, Frequency frequency) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate
          .add(Duration(days: frequency == Frequency.weekly ? 7 : 1));
    }

    return dates;
  }

  List<int> scale(List<int> data) {
    final minMax = minOrMaxArray(data);
    final max = minMax[1] + 5;
    final scaleMax = max % 2 == 0 ? max : max + 1;
    final count = scaleMax / 5;
    List<int> result = [0];
    for (int i = 1; i <= 5; i++) {
      result.add(count.toInt() * i);
    }
    return result;
  }
}
