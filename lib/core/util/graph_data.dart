import 'package:reentry/core/extensions.dart';

class GraphData {
  static final randomDates = [

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

  List<int> monthlyYAxis(List<int> timeLines){

    final first = DateTime.now().copyWith(month: 1,day: 1);
    List<int> yAxisOutput = [];
    const timeFrame = 30;
    for(int i =1;i<=12;i++){
      final currentDate =
      first.add(Duration(days: timeFrame * i)); //create week from first
      final monthCount = _numberOfDatesInRange(timeLines, currentDate);
      yAxisOutput.add(monthCount);
    }
    return yAxisOutput;
  }
  int _numberOfDatesInRange(List<int> timeLine,DateTime date){
    int count = 0;
    for(var i in timeLine){
      final time = DateTime.fromMillisecondsSinceEpoch(i);
      final dateFormat =time.formatDate(format: "MMM y");
      if(dateFormat == date.formatDate(format: 'MMM y')){
        count++;
      }
    }
    return count;
  }
  List<int> generateDataForYAxis(List<int> timeLine,
  {bool monthly=false}
     ) {
    int count = 0;
    final first = monthly?DateTime.now().copyWith(month: 1,day: 1): DateTime.fromMillisecondsSinceEpoch(timeLine.first);
    int epoc = 1;
    final timeFrame = monthly?30: 7;
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
