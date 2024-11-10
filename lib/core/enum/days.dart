enum Days { sun, mon, tue, wed, thu, fri, sat }

extension DaysExtentions on Days {
  String getName() {
    switch (this) {
      case Days.sun:
        return "Sunday";
      case Days.mon:
        return "Monday";
      case Days.tue:
        return "Tuesday";
      case Days.wed:
        return "Wednesday";
      case Days.thu:
        return "Thursday";
      case Days.fri:
        return "Friday";
      case Days.sat:
        return "Saturday";
      default:
        return "None";
    }
  }
}
