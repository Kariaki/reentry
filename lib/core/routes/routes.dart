import 'package:reentry/ui/modules/activities/activity_screen.dart';
import 'package:reentry/ui/modules/activities/daily_progress_screen.dart';
import 'package:reentry/ui/modules/calender/calender_screen.dart';
import 'package:reentry/ui/modules/clients/clients_screen.dart';
import 'package:reentry/ui/modules/goals/goals_screen.dart';

class AppRoutes {
  static const goals = '/goals';
  static const clients = '/clients';
  static const progress = '/progress';
  static const dailyActions = '/dailyActions';
  static const calender = '/calender';
  static const activities = '/activities';
  static Map<String, dynamic> routes = {
    clients: ClientsScreen(),
    calender: CalenderScreen(),
    goals: GoalsScreen(),
    dailyActions: ActivityScreen(),
    progress: DailyProgressScreen()
  };
}
