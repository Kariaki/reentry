import 'package:reentry/core/extensions.dart';

class GraphData {
  static final randomDates = [
    // Week 1 (4 days)
    DateTime(2024, 11, 8), // Tuesday
    DateTime(2024, 11, 10), // Thursday
    DateTime(2024, 11, 12), // Sunday

    // Week 2 (6 days)
    DateTime(2024, 11, 15), // Tuesday
    DateTime(2024, 11, 18), // Wednesday
    DateTime(2024, 11, 20), // Sunday
    DateTime(2024, 11, 21), // Monday

    // Week 3 (2 days)
    DateTime(2024, 11, 25), // Tuesday
    DateTime(2024, 11, 26), // Thursday

    // Week 4 (1 day)
    DateTime(2024, 12, 2), // Monday

    // Week 5 (5 days)
    DateTime(2024, 12, 7), // Wednesday
    DateTime(2024, 12, 10), // Thursday
    DateTime(2024, 12, 11), // Saturday
    DateTime(2024, 12, 12), // Sunday
    DateTime(2024, 12, 9), // Monday
  ].map((e) => e.millisecondsSinceEpoch).toList();

  List<int> generateWeeklyDataForYAxis(List<int> timeLine,
     ) {
    int count = 0;
    final first = DateTime.fromMillisecondsSinceEpoch(timeLine.first);
    int epoc = 1;
    const timeFrame = 7;
    List<int> yAxisOutput = [];
    int counter = 0;
    final lastIndex = timeLine.length-1;
    for (var i in timeLine) {
      final currentWeek =
          first.add(Duration(days: timeFrame * epoc)); //create week from first
      final currentDate = DateTime.fromMillisecondsSinceEpoch(i);
      final sameTimeFrame = currentDate.isBefore(currentWeek);
      if (sameTimeFrame) {
        count++;
        if(lastIndex==counter){
          yAxisOutput.add(count);
        }
      } else {
        yAxisOutput.add(count);
        count = 1;
        epoc++;
      }
      counter++;
    }
    return yAxisOutput;
  }
}
